defmodule GodwokenExplorerWeb.API.WithdrawalHistoryController do
  use GodwokenExplorerWeb, :controller

  alias GodwokenExplorer.WithdrawalHistoryView

  def index(conn, %{"owner_lock_hash" => "0x" <> _} = params) do
    results = WithdrawalHistoryView.find_by_owner_lock_hash(String.downcase(params["owner_lock_hash"]), conn.params["page"] || 1)
    data = JSONAPI.Serializer.serialize(WithdrawalHistoryView, results.entries, conn, %{total_page: results.total_pages, current_page: results.page_number} )
    json(conn, data)
  end

  def index(conn, %{"l2_script_hash" => "0x" <> _} = params) do
    results = WithdrawalHistoryView.find_by_l2_script_hash(String.downcase(params["l2_script_hash"]), conn.params["page"] || 1)
    data = JSONAPI.Serializer.serialize(WithdrawalHistoryView, results.entries, conn, %{total_page: results.total_pages, current_page: results.page_number} )
    json(conn, data)
  end

  def index(conn, _) do
    json(conn, %{
        error_code: 400,
        message: "bad request"
      })
  end
end
