defmodule GodwokenExplorer.Graphql.Types.AccountUDT do
  use Absinthe.Schema.Notation
  alias GodwokenExplorer.Graphql.Resolvers, as: Resolvers
  alias GodwokenExplorer.Graphql.Middleware.Downcase, as: MDowncase
  alias GodwokenExplorer.Graphql.Middleware.TermRange, as: MTermRange

  object :account_udt_querys do
    @desc """
    function: get list of account udt by account addresses

    request-example:
    query {
      account_udts(input: {address_hashes: ["0x15ca4f2165ff0e798d9c7434010eaacc4d768d85", "0xc20538aa80bb3ced9e240dc8f8130b7f7d0b0c49"],
          token_contract_address_hash: "0xbf1f27daea43849b67f839fd101569daaa321e2c"}) {
        address_hash
        balance
        udt{
          type
          name
        }
      }
    }

    result-example:
    {
      "data": {
        "account_udts": [
          {
            "address_hash": "0x15ca4f2165ff0e798d9c7434010eaacc4d768d85",
            "balance": "993799999325",
            "udt": {
              "name": "Nervos Token",
              "type": "BRIDGE"
            }
          },
          {
            "address_hash": "0xc20538aa80bb3ced9e240dc8f8130b7f7d0b0c49",
            "balance": "950876407191",
            "udt": {
              "name": "Nervos Token",
              "type": "BRIDGE"
            }
          }
        ]
      }
    }
    """
    field :account_udts, list_of(:account_udt) do
      arg(:input, non_null(:account_udts_input))
      middleware(MDowncase, [:address_hashes, :token_contract_address_hash])
      middleware(MTermRange, MTermRange.page_and_size_default_config())
      resolve(&Resolvers.AccountUDT.account_udts/3)
    end

    @desc """
    function: get list of account ckbs by account addresses

    request-example:
    query {
      account_ckbs(input: {address_hashes: ["0x15ca4f2165ff0e798d9c7434010eaacc4d768d85"]}){
        address_hash
        balance
      }
    }

    result-example:
    {
      "data": {
        "account_ckbs": [
          {
            "address_hash": "0x15ca4f2165ff0e798d9c7434010eaacc4d768d85",
            "balance": "993799999325"
          }
        ]
      }
    }

    """
    field :account_ckbs, list_of(:account_ckb) do
      arg(:input, non_null(:account_ckbs_input))
      middleware(MDowncase, [:address_hashes])
      resolve(&Resolvers.AccountUDT.account_ckbs/3)
    end

    @desc """
    function: get list account udts by smart contract address which sort of balance

    request-example:
    query {
      account_udts_by_contract_address(input: {token_contract_address_hash: "0xbf1f27daea43849b67f839fd101569daaa321e2c", page_size: 2}){
        address_hash
        balance
        udt {
          type
    	    name
        }
      }
    }

    result-example:
    {
      "data": {
        "account_udts_by_contract_address": [
          {
            "address_hash": "0x68f5cea51fa6fcfdcc10f6cddcafa13bf6717436",
            "balance": "3711221022882427",
            "udt": {
              "name": "Nervos Token",
              "type": "BRIDGE"
            }
          },
          {
            "address_hash": "0x7c12cbcbc3703bff1230434f792d84d70d47bb6f",
            "balance": "1075120930414037",
            "udt": {
              "name": "Nervos Token",
              "type": "BRIDGE"
            }
          }
        ]
      }
    }
    """
    field :account_udts_by_contract_address, list_of(:account_udt) do
      arg(:input, non_null(:account_udt_contract_address_input))
      middleware(MDowncase, [:token_contract_address_hash])
      middleware(MTermRange, MTermRange.page_and_size_default_config())
      resolve(&Resolvers.AccountUDT.account_udts_by_contract_address/3)
    end
  end

  object :account_ckb do
    field :address_hash, :string
    field :balance, :decimal
  end

  object :account_udt do
    field :id, :integer
    field :balance, :decimal
    field :address_hash, :string
    field :token_contract_address_hash, :string

    field :udt, :udt do
      resolve(&Resolvers.AccountUDT.udt/3)
    end

    field :account, :account do
      resolve(&Resolvers.AccountUDT.account/3)
    end
  end

  input_object :account_ckbs_input do
    field :address_hashes, list_of(:string), default_value: []
  end

  input_object :account_udts_input do
    import_fields(:page_and_size_input)

    @desc """
    argument: the list of account udt address
    example: ["0x15ca4f2165ff0e798d9c7434010eaacc4d768d85"]
    """
    field :address_hashes, list_of(:string), default_value: []

    @desc """
    argument: the address of smart contract which supply udts
    example: "0xbf1f27daea43849b67f839fd101569daaa321e2c"
    """
    field :token_contract_address_hash, :string
  end

  input_object :account_udt_contract_address_input do
    import_fields(:page_and_size_input)
    import_fields(:sort_type_input)
    field :token_contract_address_hash, non_null(:string)
  end
end
