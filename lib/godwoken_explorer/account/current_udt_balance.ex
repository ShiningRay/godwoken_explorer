defmodule GodwokenExplorer.Account.CurrentUDTBalance do
  use GodwokenExplorer, :schema

  import GodwokenRPC.Util, only: [balance_to_view: 2]

  require Logger

  alias GodwokenRPC
  alias GodwokenExplorer.Chain.Hash

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "account_current_udt_balances" do
    field :value, :decimal
    field(:value_fetched_at, :utc_datetime_usec)
    field(:block_number, :integer)
    field :address_hash, Hash.Address
    field :token_contract_address_hash, Hash.Address
    belongs_to(:account, GodwokenExplorer.Account, foreign_key: :account_id, references: :id)
    belongs_to(:udt, GodwokenExplorer.UDT, foreign_key: :udt_id, references: :id)

    timestamps()
  end

  @doc false
  def changeset(account_udt, attrs) do
    account_udt
    |> cast(attrs, [
      :account_id,
      :udt_id,
      :address_hash,
      :token_contract_address_hash,
      :value,
      :value_fetched_at,
      :block_number
    ])
    |> validate_required([:address_hash, :token_contract_address_hash])
    |> unique_constraint([:address_hash, :token_contract_address_hash])
  end

  def list_udt_by_eth_address(eth_address) do
    udt_balances =
      from(cub in CurrentUDTBalance,
        join: a1 in Account,
        on: a1.eth_address == cub.token_contract_address_hash,
        join: u2 in UDT,
        on: u2.bridge_account_id == a1.id,
        where: cub.address_hash == ^eth_address and cub.value != 0,
        select: %{
          id: u2.id,
          type: u2.type,
          name: u2.name,
          symbol: u2.symbol,
          icon: u2.icon,
          balance: cub.value,
          udt_decimal: u2.decimal,
          updated_at: cub.updated_at
        }
      )
      |> Repo.all()

    bridged_udt_balances =
      from(cbub in CurrentBridgedUDTBalance,
        join: a1 in Account,
        on: a1.script_hash == cbub.udt_script_hash,
        join: u2 in UDT,
        on: u2.id == a1.id,
        where: cbub.address_hash == ^eth_address and cbub.value != 0,
        select: %{
          id: u2.id,
          type: u2.type,
          name: u2.name,
          symbol: u2.symbol,
          icon: u2.icon,
          balance: cbub.value,
          udt_decimal: u2.decimal,
          updated_at: cbub.updated_at
        }
      )
      |> Repo.all()

    (bridged_udt_balances ++ udt_balances)
    |> Enum.sort_by(&Map.fetch(&1, :updated_at))
    |> Enum.uniq_by(&Map.fetch(&1, :id))
    |> Enum.map(fn record ->
      record
      |> Map.merge(%{balance: balance_to_view(record[:balance], record[:udt_decimal] || 0)})
    end)
  end

  def filter_ckb_balance(udt_balances) do
    udt_balances |> Enum.filter(fn ub -> ub.id == UDT.ckb_account_id() end)
  end

  def get_ckb_balance(addresses) do
    [ckb_bridged_address, ckb_contract_address] =
      UDT.ckb_account_id() |> UDT.list_address_by_udt_id()

    bridged_results =
      from(cbub in CurrentBridgedUDTBalance,
        where: cbub.address_hash in ^addresses and cbub.udt_script_hash == ^ckb_bridged_address,
        select: %{
          address_hash: cbub.address_hash,
          balance: cbub.value,
          updated_at: cbub.updated_at
        }
      )
      |> Repo.all()

    if ckb_contract_address != nil do
      results =
        from(cub in CurrentUDTBalance,
          where:
            cub.address_hash in ^addresses and
              cub.token_contract_address_hash == ^ckb_contract_address,
          select: %{
            address_hash: cub.address_hash,
            balance: cub.value,
            updated_at: cub.updated_at
          }
        )
        |> Repo.all()

      (bridged_results ++ results)
      |> Enum.sort_by(&Map.fetch(&1, :updated_at))
      |> Enum.uniq_by(&Map.fetch(&1, :address_hash))
    else
      bridged_results
    end
    |> Enum.map(fn result ->
      %{
        balance: result[:balance],
        address: result[:address_hash]
      }
    end)
  end

  def sort_holder_list(udt_id, paging_options) do
    case Repo.get(UDT, udt_id) do
      %UDT{type: :native, supply: supply, decimal: decimal} ->
        [token_contract_address_hashes] = UDT.list_address_by_udt_id(udt_id)

        address_and_balances =
          from(cub in CurrentUDTBalance,
            join: a1 in Account,
            on: a1.eth_address == cub.address_hash,
            where:
              cub.token_contract_address_hash == ^token_contract_address_hashes and cub.value > 0,
            select: %{
              eth_address: cub.address_hash,
              balance: cub.value,
              tx_count:
                fragment(
                  "CASE WHEN ? is null THEN 0 ELSE ? END",
                  a1.transaction_count,
                  a1.transaction_count
                )
            },
            order_by: [desc: cub.balance]
          )
          |> Repo.paginate(page: paging_options[:page], page_size: paging_options[:page_size])

        parse_holder_sort_results(address_and_balances, supply, decimal || 0)

      %UDT{type: :bridge, supply: supply, decimal: decimal} ->
        [udt_script_hash, token_contract_address_hashes] = UDT.list_address_by_udt_id(udt_id)

        udt_balance_query =
          from(cub in CurrentUDTBalance,
            where:
              cub.token_contract_address_hash == ^token_contract_address_hashes and cub.value > 0,
            select: %{
              eth_address: cub.address_hash,
              balance: cub.value,
              updated_at: cub.updated_at
            }
          )

        bridged_udt_balance_query =
          from(cbub in CurrentBridgedUDTBalance,
            where: cbub.udt_script_hash == ^udt_script_hash and cbub.value > 0,
            select: %{
              eth_address: cbub.address_hash,
              balance: cbub.value,
              updated_at: cbub.updated_at
            }
          )

        address_and_balances =
          from(q in subquery(union_all(udt_balance_query, ^bridged_udt_balance_query)),
            join: a in Account,
            on: a.eth_address == q.eth_address,
            select: %{
              eth_address: q.address_hash,
              balance: q.value,
              tx_count: a.transaction_count
            },
            order_by: [desc: :updated_at, desc: :balance],
            distinct: q.eth_address
          )
          |> Repo.paginate(page: paging_options[:page], page_size: paging_options[:page_size])

        parse_holder_sort_results(address_and_balances, supply, decimal || 0)
    end
  end

  defp parse_holder_sort_results(address_and_balances, supply, decimal) do
    results =
      address_and_balances.entries
      |> Enum.map(fn %{balance: balance} = result ->
        percentage =
          if is_nil(supply) do
            0.0
          else
            D.div(balance, supply) |> D.mult(D.new(100)) |> D.round(2) |> D.to_string()
          end

        result
        |> Map.merge(%{
          percentage: percentage,
          balance: D.div(balance, Integer.pow(10, decimal))
        })
      end)

    %{
      page: address_and_balances.page_number,
      total_count: address_and_balances.total_entries,
      results: results
    }
  end
end