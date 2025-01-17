defmodule GodwokenExplorer.Graphql.Resolvers.TokenTransfer do
  alias GodwokenExplorer.{TokenTransfer, Polyjuice, Account, UDT, Block, Transaction}

  alias GodwokenExplorer.Repo

  import Ecto.Query
  import GodwokenExplorer.Graphql.Common, only: [page_and_size: 2, sort_type: 3]

  def token_transfers(_parent, %{input: input}, _resolution) do
    query = query_token_transfers(input)
    return = Repo.all(query)
    {:ok, return}
  end

  def polyjuice(%TokenTransfer{transaction_hash: transaction_hash}, _args, _resolution) do
    return = Repo.one(from p in Polyjuice, where: p.tx_hash == ^transaction_hash)
    {:ok, return}
  end

  def block(%TokenTransfer{block_hash: block_hash}, _args, _resolution) do
    if block_hash do
      return = Repo.get(Block, block_hash)
      {:ok, return}
    else
      {:ok, nil}
    end
  end

  def from_account(%TokenTransfer{from_address_hash: from_address_hash}, _args, _resolution) do
    if from_address_hash do
      return = from(a in Account, where: a.short_address == ^from_address_hash) |> Repo.one()
      {:ok, return}
    else
      {:ok, nil}
    end
  end

  def to_account(%TokenTransfer{to_address_hash: to_address_hash}, _args, _resolution) do
    if to_address_hash do
      return = from(a in Account, where: a.short_address == ^to_address_hash) |> Repo.one()
      {:ok, return}
    else
      {:ok, nil}
    end
  end

  def udt(
        %TokenTransfer{token_contract_address_hash: token_contract_address_hash},
        _args,
        _resolution
      ) do
    udt = UDT.get_by_contract_address(token_contract_address_hash)
    {:ok, udt}
  end

  def transaction(%TokenTransfer{transaction_hash: transaction_hash}, _args, _resolution) do
    return = Repo.one(from t in Transaction, where: t.hash == ^transaction_hash)
    {:ok, return}
  end

  defp query_token_transfers(input) do
    conditions =
      Enum.reduce(input, true, fn arg, acc ->
        case arg do
          {:transaction_hash, value} ->
            dynamic([tt], ^acc and tt.transaction_hash == ^value)

          {:from_address_hash, value} ->
            dynamic([tt], ^acc and tt.from_address_hash == ^value)

          {:to_address_hash, value} ->
            dynamic([tt], ^acc and tt.to_address_hash == ^value)

          {:token_contract_address_hash, value} ->
            dynamic([tt], ^acc and tt.token_contract_address_hash == ^value)

          {:start_block_number, value} ->
            dynamic([tt], ^acc and tt.block_number >= ^value)

          {:end_block_number, value} ->
            dynamic([tt], ^acc and tt.block_number <= ^value)

          _ ->
            acc
        end
      end)

    from(tt in TokenTransfer, where: ^conditions)
    |> page_and_size(input)
    |> sort_type(input, [:block_number, :log_index])
  end
end
