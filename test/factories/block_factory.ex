defmodule GodwokenExplorer.BlockFactory do
  alias GodwokenExplorer.Block

  defmacro __using__(_opts) do
    quote do
      def block_factory do
        %Block{
          hash: "0x9e449451846827df40c9a8bcb2809256011afbbf394de676d52535c3ca32a518",
          parent_hash: "0xa04ecc2bb1bc634848535b60b3223c1cd5278aa93abb2c138687da8ffa9ffd48",
          number: 14,
          timestamp: ~U[2021-10-31 05:39:38.000000Z],
          status: :finalized,
          aggregator_id: 0,
          transaction_count: 1,
          gas_limit: D.new(12_500_000),
          gas_used: D.new(0),
          size: 156,
          logs_bloom:
            "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
          layer1_block_number: 2_345_241,
          layer1_tx_hash: "0xae12080b62ec17acc092b341a6ca17da0708e7a6d77e8033c785ea48cdbdbeef"
        }
      end
    end
  end
end
