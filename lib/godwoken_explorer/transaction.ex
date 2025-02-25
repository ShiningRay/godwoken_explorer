defmodule GodwokenExplorer.Transaction do
  use GodwokenExplorer, :schema

  import GodwokenRPC.Util, only: [stringify_and_unix_maps: 1]

  alias GodwokenExplorer.Chain.Cache.Transactions
  alias GodwokenExplorer.Chain

  @tx_limit 500_000
  @account_tx_limit 100_000

  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key {:hash, :binary, autogenerate: false}
  schema "transactions" do
    field(:args, :binary)
    field(:from_account_id, :integer)
    field(:nonce, :integer)
    field(:to_account_id, :integer)
    field(:type, Ecto.Enum, values: [:polyjuice_creator, :polyjuice, :unknown])
    field(:block_number, :integer)
    field(:index, :integer)

    belongs_to(:block, Block, foreign_key: :block_hash, references: :hash, type: :binary)

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :hash,
      :block_hash,
      :type,
      :from_account_id,
      :to_account_id,
      :nonce,
      :args,
      :block_number,
      :index
    ])
    |> validate_required([
      :hash,
      :from_account_id,
      :to_account_id,
      :nonce,
      :args,
      :block_number
    ])
  end

  def last_nonce_by_address_query(account_id) do
    from(
      t in Transaction,
      select: t.nonce,
      where: t.from_account_id == ^account_id,
      order_by: [desc: :block_number],
      limit: 1
    )
  end

  # TODO: from and to may can refactor to be a single method
  def latest_10_records do
    case Transactions.all() do
      txs when is_list(txs) and length(txs) == 10 ->
        txs
        |> Enum.map(fn t ->
          t
          |> Map.take([:hash, :from, :to, :to_alias, :type])
          |> Map.merge(%{timestamp: t.inserted_at})
        end)

      _ ->
        %Block{hash: hash} =
          from(b in Block, where: b.transaction_count > 0, order_by: [desc: b.number], limit: 1)
          |> Repo.one()

        list_tx_hash_by_transaction_query(dynamic([t], t.block_hash == ^hash))
        |> limit(10)
        |> Repo.all()
        |> list_transaction_by_tx_hash()
        |> order_by([t], desc: t.block_number, desc: t.index)
        |> Repo.all()
    end
  end

  def find_by_hash(hash) do
    case list_transaction_by_tx_hash([hash]) |> Repo.one() do
      nil ->
        nil

      tx ->
        cond do
          tx.type == :polyjuice_creator ->
            creator = Repo.get_by(PolyjuiceCreator, tx_hash: tx.hash) |> Repo.preload(:udt)

            tx
            |> Map.merge(%{
              code_hash: creator.code_hash,
              hash_type: creator.hash_type,
              script_args: creator.script_args,
              fee_amount: creator.fee_amount,
              fee_udt: creator.udt.name
            })

          true ->
            contract = Repo.get_by(SmartContract, account_id: tx.to_account_id)

            tx
            |> Map.merge(%{
              contract_abi: contract && contract.abi
            })
        end
        |> stringify_and_unix_maps()
        |> Map.drop([:to_account_id])
    end
  end

  def count_of_account(%{
        type: type,
        account_id: account_id
      })
      when type == :user do
    from(t in Transaction,
      where: t.from_account_id == ^account_id,
      select: t.hash
    )
    |> Repo.aggregate(:count)
  end

  def count_of_account(%{type: type, account_id: account_id})
      when type in [:meta_contract, :polyjuice_root, :polyjuice_contract, :udt] do
    from(t in Transaction, where: t.to_account_id == ^account_id) |> Repo.aggregate(:count)
  end

  def account_transactions_data(
        %{block_hash: block_hash},
        paging_options
      ) do
    tx_hashes = list_tx_hash_by_transaction_query(dynamic([t], t.block_hash == ^block_hash))

    parse_result(tx_hashes, paging_options)
  end

  def account_transactions_data(
        %{account: account, contract: contract},
        paging_options
      ) do
    tx_hashes =
      list_tx_hash_by_transaction_query(
        dynamic([t], t.from_account_id == ^account.id and t.to_account_id == ^contract.id)
      )
      |> limit(@account_tx_limit)

    parse_result(tx_hashes, paging_options)
  end

  def account_transactions_data(
        %{type: type, account: account},
        paging_options
      )
      when type in [:meta_contract, :udt, :polyjuice_root, :polyjuice_contract] do
    condition = dynamic([t], t.to_account_id == ^account.id)

    paging_options =
      if (account.transaction_count || 0) > @account_tx_limit do
        paging_options |> Map.merge(%{options: [total_entries: @account_tx_limit]})
      else
        paging_options
      end

    tx_hashes =
      list_tx_hash_by_transaction_query(condition)
      |> limit(@account_tx_limit)

    parse_result(tx_hashes, paging_options)
  end

  def account_transactions_data(
        %{type: type, account: account},
        paging_options
      )
      when type == :user do
    condition = dynamic([t], t.from_account_id == ^account.id)

    paging_options =
      if (account.transaction_count || 0) > @account_tx_limit do
        paging_options |> Map.merge(%{options: [total_entries: @account_tx_limit]})
      else
        paging_options
      end

    tx_hashes =
      list_tx_hash_by_transaction_query(condition)
      |> limit(@account_tx_limit)

    parse_result(tx_hashes, paging_options)
  end

  def account_transactions_data(paging_options) do
    paging_options =
      if Chain.transaction_estimated_count() > @tx_limit do
        Map.merge(paging_options, %{options: [total_entries: @tx_limit]})
      else
        paging_options
      end

    tx_hashes =
      list_tx_hash_by_transaction_query(true)
      |> limit(@tx_limit)

    parse_result(tx_hashes, paging_options)
  end

  defp parse_result(tx_hashes, paging_options) do
    tx_hashes_struct =
      Repo.paginate(tx_hashes,
        page: paging_options[:page],
        page_size: paging_options[:page_size],
        options: paging_options[:options] || []
      )

    results =
      list_transaction_by_tx_hash(tx_hashes_struct.entries)
      |> order_by([t], desc: t.block_number, desc: t.index)
      |> Repo.all()

    parsed_result =
      Enum.map(results, fn record ->
        stringify_and_unix_maps(record)
        |> Map.merge(%{method: Polyjuice.get_method_name(record.to_account_id, record.input)})
        |> Map.drop([:input, :to_account_id])
      end)

    %{
      page: paging_options[:page],
      total_count: tx_hashes_struct.total_entries,
      txs: parsed_result
    }
  end

  def list_tx_hash_by_transaction_query(condition) do
    from(t in Transaction,
      select: t.hash,
      where: ^condition,
      order_by: [desc: t.inserted_at, desc: t.block_number, desc: t.index]
    )
  end

  def list_transaction_by_tx_hash(hashes) do
    from(t in Transaction,
      join: b in Block,
      on: [hash: t.block_hash],
      join: a2 in Account,
      on: a2.id == t.from_account_id,
      join: a3 in Account,
      on: a3.id == t.to_account_id,
      left_join: s4 in SmartContract,
      on: s4.account_id == t.to_account_id,
      left_join: p in Polyjuice,
      on: p.tx_hash == t.hash,
      left_join: u6 in UDT,
      on: u6.bridge_account_id == s4.account_id,
      where: t.hash in ^hashes,
      select: %{
        hash: t.hash,
        block_hash: b.hash,
        block_number: b.number,
        l1_block_number: b.layer1_block_number,
        from: a2.eth_address,
        to:
          fragment(
            "
          CASE WHEN ? = 'user' THEN encode(?, 'escape')
          WHEN ? = 'polyjuice_contract' THEN encode(?, 'escape')
           ELSE encode(?, 'escape') END",
            a3.type,
            a3.eth_address,
            a3.type,
            a3.short_address,
            a3.script_hash
          ),
        to_alias:
          fragment(
            "
          CASE WHEN ? = 'user' THEN encode(?, 'escape')
          WHEN ? = 'udt' THEN (CASE WHEN ? IS NOT NULL THEN ? ELSE encode(?, 'escape') END)
          WHEN ? = 'polyjuice_contract' THEN (CASE WHEN ? IS NOT NULL THEN ? ELSE encode(?, 'escape') END)
          WHEN ? = 'polyjuice_creator' THEN 'Deploy Contract'
          ELSE encode(?, 'escape') END",
            a3.type,
            a3.eth_address,
            a3.type,
            s4.name,
            s4.name,
            a3.script_hash,
            a3.type,
            s4.name,
            s4.name,
            a3.short_address,
            a3.type,
            a3.script_hash
          ),
        status: b.status,
        polyjuice_status: p.status,
        type: t.type,
        nonce: t.nonce,
        inserted_at: t.inserted_at,
        fee: p.gas_price * p.gas_used,
        gas_price: p.gas_price,
        gas_used: p.gas_used,
        gas_limit: p.gas_limit,
        value: p.value,
        udt_id: s4.account_id,
        transaction_index: p.transaction_index,
        udt_symbol: fragment("CASE WHEN ? IS NULL THEN ? ELSE ? END", u6, "", u6.symbol),
        udt_icon: fragment("CASE WHEN ? IS NULL THEN ? ELSE ? END", u6, "", u6.icon),
        input: p.input,
        to_account_id: t.to_account_id,
        created_contract_address_hash: p.created_contract_address_hash
      }
    )
  end
end
