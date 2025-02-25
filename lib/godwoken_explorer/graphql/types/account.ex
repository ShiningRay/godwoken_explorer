defmodule GodwokenExplorer.Graphql.Types.Account do
  use Absinthe.Schema.Notation
  alias GodwokenExplorer.Graphql.Resolvers, as: Resolvers
  alias GodwokenExplorer.Graphql.Middleware.Downcase, as: MDowncase
  alias GodwokenExplorer.Graphql.Middleware.TermRange, as: MTermRange

  object :account_querys do
    @desc """
    function: get account by account addresses

    request-example-1:
    query {
      account(input: {address: "0xbfbe23681d99a158f632e64a31288946770c7a9e"}){
        id
        type
        account_udts(input: {page: 1, page_size: 2}){
        	id
          balance
          udt{
            name
            type
          }
        }
      }
    }

    result-example-1:
    {
      "data": {
        "account": {
          "account_udts": [
            {
              "balance": "1352700556596252988061",
              "id": 22651,
              "udt": {
                "name": "Yokai",
                "type": "NATIVE"
              }
            },
            {
              "balance": "950876407191",
              "id": 21837,
              "udt": {
                "name": "Nervos Token",
                "type": "BRIDGE"
              }
            }
          ],
          "id": 51118,
          "type": "USER"
        }
      }
    }

    request-example-2:
    query {
      account(input: {address: "0xc5e133e6b01b2c335055576c51a53647b1b9b624"}){
        id
        type
        smart_contract{
          id
          name
          deployment_tx_hash
        }
      }
    }

    result-example-2:
    {
      "data": {
        "account": {
          "id": 3014,
          "smart_contract": {
            "deployment_tx_hash": "0x0000000000",
            "id": 1,
            "name": "YOKAI"
          },
          "type": "POLYJUICE_CONTRACT"
        }
      }
    }
    """
    field :account, :account do
      arg(:input, non_null(:account_input))
      middleware(MDowncase, [:address])
      resolve(&Resolvers.Account.account/3)
    end
  end

  object :account_mutations do
  end

  object :account do
    field :id, :integer
    field :eth_address, :string
    field :script_hash, :string
    field :short_address, :string
    field :script, :json
    field :nonce, :integer
    field :type, :account_type
    field :transaction_count, :integer
    field :token_transfer_count, :integer

    field :account_udts, list_of(:account_udt) do
      arg(:input, :account_child_account_udts_input,
        default_value: %{page: 1, page_size: 20, sort_type: :desc}
      )

      middleware(MTermRange, MTermRange.page_and_size_default_config())
      resolve(&Resolvers.Account.account_udts/3)
    end

    field :smart_contract, :smart_contract do
      resolve(&Resolvers.Account.smart_contract/3)
    end
  end

  enum :account_type do
    value(:meta_contract)
    value(:udt)
    value(:user)
    value(:polyjuice_root)
    value(:polyjuice_contract)
  end

  input_object :account_input do
    @desc """
    argument: account address(eth_address or short_address)
    example-1: "0x15ca4f2165ff0e798d9c7434010eaacc4d768d85"
    example-2: "0xc5e133e6b01b2c335055576c51a53647b1b9b624"
    """
    field :address, non_null(:string)
  end

  input_object :account_child_account_udts_input do
    import_fields(:page_and_size_input)
    import_fields(:sort_type_input)
  end
end
