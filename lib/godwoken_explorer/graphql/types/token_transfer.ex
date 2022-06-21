defmodule GodwokenExplorer.Graphql.Types.TokenTransfer do
  use Absinthe.Schema.Notation
  alias GodwokenExplorer.Graphql.Resolvers, as: Resolvers
  alias GodwokenExplorer.Graphql.Middleware.EIP55, as: MEIP55
  alias GodwokenExplorer.Graphql.Middleware.Downcase, as: MDowncase

  object :token_transfer_querys do
    @desc """
    function: get list of token transfers by filter

    request-result-example:
    query {
      token_transfers(
        input: {
          from_address: "0x966b30e576a4d6731996748b48dd67c94ef29067"
          to_address: "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
          start_block_number: 1
          end_block_number: 11904
          limit: 10
          sort_type: DESC
					combine_from_to: true
        }
      ) {
        entries {
          transaction_hash
          block_number
          to_account {
            eth_address
          }
          to_address
          from_account {
            eth_address
          }
        }

        metadata {
          total_count
          before
          after
        }
      }
    }

    {
      "data": {
        "token_transfers": {
          "entries": [
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0x2c70095a3a15a173517fc8d95c505add5242c3287da72907f5ffa1c0b6cc9578"
            },
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0x954fd1d5645c49c62008a842839fc9ea134453aa0e30120af23f78fac276b33b"
            },
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0xaf0be54aadf00c5717e9380269146ab7e330cc195a2e5c181480aef1a4f552e7"
            },
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0x934d9c939dcabf5c03c2828b0d74262a5c9b0aa86732a8cfc7bc03c8830bd1fc"
            },
            {
              "block_number": 11463,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd"
              },
              "to_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd",
              "transaction_hash": "0x1a6274fd71b48c74537390bab79cc41a62560c5f5061cf44baa585fd898aa1d2"
            },
            {
              "block_number": 11462,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd"
              },
              "to_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd",
              "transaction_hash": "0xfdb7a5fd9ac99a4e1fcf6f81424299d9ccc91a0c5e30c07bb1b2a6e02564d71c"
            },
            {
              "block_number": 11462,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd"
              },
              "to_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd",
              "transaction_hash": "0x6de7fab87aa6b363462ba19a3cb23865a4b031d809f181d12d25f20bf47641b8"
            },
            {
              "block_number": 11462,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd"
              },
              "to_address": "0x0e86065dcac317eb6c6a46551672e9551c16f0dd",
              "transaction_hash": "0xd56ae47ca7fb342d646b3aa1277ff94dee9ccfefbc3d5085315a0f3564563a6f"
            },
            {
              "block_number": 11371,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xc69f97a51f36f7f0c545ca9b2e784acd60de95eb"
              },
              "to_address": "0xc69f97a51f36f7f0c545ca9b2e784acd60de95eb",
              "transaction_hash": "0x2090f0d6954484c8fdbefcd017b14d56d2b21e6e37cf4eb5c7f809be7a94d156"
            },
            {
              "block_number": 11371,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xc69f97a51f36f7f0c545ca9b2e784acd60de95eb"
              },
              "to_address": "0xc69f97a51f36f7f0c545ca9b2e784acd60de95eb",
              "transaction_hash": "0xac13f170691b6fafae5d4fe8b95dc52057d223d23e238ff8af66fdf085a058b6"
            }
          ],
          "metadata": {
            "after": "g3QAAAADZAAMYmxvY2tfbnVtYmVyYgAALGtkAAlsb2dfaW5kZXhhAWQAEHRyYW5zYWN0aW9uX2hhc2htAAAAQjB4YWMxM2YxNzA2OTFiNmZhZmFlNWQ0ZmU4Yjk1ZGM1MjA1N2QyMjNkMjNlMjM4ZmY4YWY2NmZkZjA4NWEwNThiNg==",
            "before": null,
            "total_count": 60
          }
        }
      }
    }

    request-example-result:
    query {
      token_transfers(
        input: {
          from_address: "0x966b30e576a4d6731996748b48dd67c94ef29067"
          to_address: "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
          start_block_number: 1
          end_block_number: 11904
          limit: 10
          sort_type: DESC
					combine_from_to: false
        }
      ) {
        entries {
          transaction_hash
          block_number
          to_account {
            eth_address
          }
          to_address
          from_account {
            eth_address
          }
        }

        metadata {
          total_count
          before
          after
        }
      }
    }

    {
      "data": {
        "token_transfers": {
          "entries": [
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0xaf0be54aadf00c5717e9380269146ab7e330cc195a2e5c181480aef1a4f552e7"
            },
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0x954fd1d5645c49c62008a842839fc9ea134453aa0e30120af23f78fac276b33b"
            },
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0x934d9c939dcabf5c03c2828b0d74262a5c9b0aa86732a8cfc7bc03c8830bd1fc"
            },
            {
              "block_number": 11904,
              "from_account": {
                "eth_address": "0x966b30e576a4d6731996748b48dd67c94ef29067"
              },
              "to_account": {
                "eth_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413"
              },
              "to_address": "0xbd6250d17fc557dfe39a9eb3882c421d4c7f6413",
              "transaction_hash": "0x2c70095a3a15a173517fc8d95c505add5242c3287da72907f5ffa1c0b6cc9578"
            }
          ],
          "metadata": {
            "after": null,
            "before": null,
            "total_count": 4
          }
        }
      }
    }
    """
    field :token_transfers, :paginate_token_transfers do
      arg(:input, non_null(:token_transfer_input))

      middleware(MEIP55, [
        :from_address,
        :to_address,
        :token_contract_address_hash
      ])

      middleware(MDowncase, [
        :transaction_hash,
        :from_address,
        :to_address,
        :token_contract_address_hash
      ])

      resolve(&Resolvers.TokenTransfer.token_transfers/3)
    end
  end

  object :paginate_token_transfers do
    field :entries, list_of(:token_transfer)
    field :metadata, :paginate_metadata
  end

  object :token_transfer do
    field :transaction_hash, :hash_full
    field :amount, :decimal
    field :block_number, :integer
    field :block_hash, :hash_full
    field :log_index, :integer
    field :token_id, :decimal

    field :from_address, :hash_address do
      resolve(&Resolvers.TokenTransfer.from_address/3)
    end

    field :to_address, :hash_address do
      resolve(&Resolvers.TokenTransfer.to_address/3)
    end

    field :token_contract_address_hash, :hash_address

    field :polyjuice, :polyjuice do
      resolve(&Resolvers.TokenTransfer.polyjuice/3)
    end

    field :from_account, :account do
      resolve(&Resolvers.TokenTransfer.from_account/3)
    end

    field :to_account, :account do
      resolve(&Resolvers.TokenTransfer.to_account/3)
    end

    field :udt, :udt do
      resolve(&Resolvers.TokenTransfer.udt/3)
    end

    field :block, :block do
      resolve(&Resolvers.TokenTransfer.block/3)
    end

    field :transaction, :transaction do
      resolve(&Resolvers.TokenTransfer.transaction/3)
    end
  end

  input_object :token_transfer_input do
    field :transaction_hash, :hash_full
    field :from_address, :hash_address
    field :to_address, :hash_address
    @desc """
    if combine_from_to is true, then from_address and to_address are combined into query condition like `address = from_address OR address = to_address`
    """
    field :combine_from_to, :boolean, default_value: true
    field :token_contract_address_hash, :hash_address
    import_fields(:paginate_input)
    import_fields(:block_range_input)
    import_fields(:sort_type_input)
  end
end
