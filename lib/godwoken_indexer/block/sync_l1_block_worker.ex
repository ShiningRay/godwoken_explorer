defmodule GodwokenIndexer.Block.SyncL1BlockWorker do
  use GenServer

  import Godwoken.MoleculeParser, only: [parse_deposition_lock_args: 1]
  import GodwokenRPC.Util, only: [hex_to_number: 1, script_to_hash: 1, parse_le_number: 1]

  require Logger

  alias GodwkenRPC
  alias GodwokenExplorer.{Account, CheckInfo, Repo, Block, DepositHistory, AccountUDT}

  @default_worker_interval 5

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  @spec init(any) :: {:ok, any}
  def init(state) do
    init_godwoken_l1_block_number =
      Application.get_env(:godwoken_explorer, :init_godwoken_l1_block_number)

    start_block_number =
      case Repo.get_by(CheckInfo, type: "main_deposit") do
        %CheckInfo{tip_block_number: l1_block_number} when is_integer(l1_block_number) ->
          l1_block_number + 1

        nil ->
          init_godwoken_l1_block_number
      end

    schedule_work(start_block_number)

    {:ok, state}
  end

  def handle_info({:bind_deposit_work, block_number}, state) do
    {:ok, l1_tip_number} = GodwokenRPC.fetch_l1_tip_block_nubmer()

    {:ok, next_block_number} =
      if block_number <= l1_tip_number do
        {:ok, _new_block_number} = fetch_deposition_script_and_update(block_number)
      else
        {:ok, block_number}
      end

    schedule_work(next_block_number)

    {:noreply, state}
  end

  def fetch_deposition_script_and_update(block_number) do
    deposition_lock = Application.get_env(:godwoken_explorer, :deposition_lock)
    check_info = Repo.get_by(CheckInfo, type: :main_deposit)
    {:ok, response} = GodwokenRPC.fetch_l1_block(block_number)
    header = response["header"]
    block_hash = header["hash"]

    if forked?(header["parent_hash"], check_info) do
      Logger.error("!!!!!!forked!!!!!!#{block_number}")

      Repo.transaction(fn ->
        Block.reset_layer1_bind_info!(check_info.tip_block_number)
        DepositHistory.rollback!(check_info.tip_block_number)
        CheckInfo.rollback!(check_info)
      end)

      throw(:rollback)
    end

    response["transactions"]
    |> Enum.each(fn tx ->
      tx["outputs"]
      |> Enum.with_index()
      |> Enum.each(fn {output, index} ->
        if output["lock"]["code_hash"] == deposition_lock.code_hash &&
             String.starts_with?(output["lock"]["args"], deposition_lock.args) do
          parse_lock_args_and_bind(
            output,
            block_number,
            tx["hash"],
            tx["outputs_data"] |> Enum.at(index),
            index
          )
        end
      end)
    end)

    CheckInfo.create_or_update_info(%{
      type: :main_deposit,
      tip_block_number: block_number,
      block_hash: block_hash
    })

    {:ok, block_number + 1}
  end

  defp parse_lock_args_and_bind(output, l1_block_number, tx_hash, output_data, index) do
    [script_hash, l1_lock_hash] = parse_lock_args(output["lock"]["args"])
    {udt_script, udt_script_hash, amount} = parse_udt_script(output, output_data)
    {:ok, hex_account_id} = GodwokenRPC.fetch_account_id(script_hash)
    account_id = hex_account_id |> hex_to_number()
    nonce = GodwokenRPC.fetch_nonce(account_id)
    short_address = String.slice(script_hash, 0, 42)
    script = GodwokenRPC.fetch_script(script_hash)
    type = Account.switch_account_type(script["code_hash"], script["args"])
    eth_address = Account.script_to_eth_adress(type, script["args"])
    parsed_script = Account.add_name_to_polyjuice_script(type, script)

    Repo.transaction(fn ->
      case Repo.get_by(Account, script_hash: script_hash) do
        %Account{id: id} ->
          if id != account_id do
            Logger.error(
              "Account id is changed!!!!old id:#{id}, new id: #{account_id}, script_hash: #{script_hash}"
            )
          end

          Account.create_or_update_account!(%{
            id: account_id,
            script_hash: script_hash,
            nonce: nonce
          })

        nil ->
          Account.create_or_update_account!(%{
            id: account_id,
            script: parsed_script,
            script_hash: script_hash,
            short_address: short_address,
            type: type,
            nonce: nonce,
            eth_address: eth_address,
            ckb_lock_hash: l1_lock_hash
          })
      end

      with {:ok, udt_id} <- Account.find_or_create_udt_account!(udt_script, udt_script_hash) do
        DepositHistory.create!(%{
          layer1_block_number: l1_block_number,
          layer1_tx_hash: tx_hash,
          udt_id: udt_id,
          amount: amount,
          ckb_lock_hash: l1_lock_hash,
          script_hash: script_hash,
          layer1_output_index: index
        })

        AccountUDT.sync_balance!(account_id, udt_id)
      end
    end)
  end

  defp parse_udt_script(output, output_data) do
    case Map.get(output, "type") do
      nil ->
        {nil, "0x0000000000000000000000000000000000000000000000000000000000000000",
         hex_to_number(output["capacity"])}

      %{} = udt_script ->
        {udt_script, script_to_hash(udt_script),
         output_data |> String.slice(2..-1) |> parse_le_number}
    end
  end

  defp parse_lock_args(args) do
    args
    |> String.slice(2..-1)
    |> parse_deposition_lock_args()
    |> Tuple.to_list()
    |> Enum.map(fn x ->
      "0x" <> x
    end)
  end

  defp schedule_work(start_block_number) do
    second =
      Application.get_env(:godwoken_explorer, :sync_deposition_worker_interval) ||
        @default_worker_interval

    Process.send_after(self(), {:bind_deposit_work, start_block_number}, second * 1000)
  end

  defp forked?(parent_hash, check_info) do
    if is_nil(check_info) || is_nil(check_info.block_hash) do
      false
    else
      parent_hash != check_info.block_hash
    end
  end
end