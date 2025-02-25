defmodule GodwokenExplorerWeb.API.AccountController do
  use GodwokenExplorerWeb, :controller

  action_fallback GodwokenExplorerWeb.API.FallbackController

  alias GodwokenExplorer.{Repo, Account}
  alias GodwokenExplorer.Counters.{AddressTokenTransfersCounter, AddressTransactionsCounter}

  def show(conn, %{"id" => "0x" <> _} = params) do
    downcase_id = params["id"] |> String.downcase()

    case Account.search(downcase_id) do
      %Account{id: id} = account ->
        fetch_transfer_and_transaction_count(account)

        result =
          id
          |> Account.find_by_id()
          |> Account.account_to_view()

        json(
          conn,
          result
        )

      nil ->
        result = Account.non_create_account_info(downcase_id)

        json(
          conn,
          result
        )
    end
  end

  def show(conn, %{"id" => id}) do
    case id |> Integer.parse() do
      {num, ""} ->
        case Repo.get(Account, num) do
          %Account{} ->
            result =
              id
              |> Account.find_by_id()
              |> Account.account_to_view()

            json(
              conn,
              result
            )

          nil ->
            {:error, :not_found}
        end

      _ ->
        {:error, :not_found}
    end
  end

  defp fetch_transfer_and_transaction_count(account) do
    Task.async(fn ->
      AddressTokenTransfersCounter.fetch(account)
    end)

    Task.async(fn ->
      AddressTransactionsCounter.fetch(account)
    end)
  end
end
