defmodule GodwokenExplorerWeb.TransactionChannel do
  @moduledoc """
  Establishes pub/sub channel for live updates of block events.
  """
  use GodwokenExplorerWeb, :channel

  alias GodwokenExplorer.Transaction

  intercept(["refresh"])

  def join("transactions:" <> tx_hash, _params, socket) do
    tx = Transaction.find_by_hash(tx_hash)

    if tx == %{} do
      {:error, %{reason: "may be a pending tx"}}
    else
      {:ok, tx, assign(socket, :tx_hash, tx_hash)}
    end
  end

  def handle_out(
        "refresh",
        %{l1_block_number: l1_block_number, status: status},
        socket
      ) do
    push(socket, "refresh", %{
      l1_block: l1_block_number,
      finalize_state: status
    })

    {:noreply, socket}
  end
end
