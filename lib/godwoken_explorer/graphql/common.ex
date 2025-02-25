defmodule GodwokenExplorer.Graphql.Common do
  import Ecto.Query

  def page_and_size(query, input, max_limit \\ 100) do
    page = Map.get(input, :page)
    page_size = Map.get(input, :page_size)

    case {page, page_size} do
      {nil, nil} ->
        query

      {nil, _} ->
        query

      {_, nil} ->
        query

      {page, page_size} when is_integer(page) and is_integer(page_size) ->
        page_size =
          if max_limit > page_size do
            page_size
          else
            max_limit
          end

        query
        |> offset((^page - 1) * ^page_size)
        |> limit(^page_size)

      _ ->
        query
    end
  end

  def sort_type(query, input, value) do
    sort_condtion = Map.get(input, :sort_type)

    values =
      if is_list(value) do
        List.duplicate(sort_condtion, length(value))
        |> Enum.zip(value)
      else
        [{sort_condtion, value}]
      end

    if sort_condtion in [:asc, :desc] do
      query
      |> order_by(^values)
    else
      query
    end
  end
end
