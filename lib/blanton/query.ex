defmodule Blanton.Query do
  alias Blanton.Query.{Select, From, Where, Order, Limit}
  require IEx

  def build(dataset_id, table, conds) do
    sql = generate_sql(dataset_id, table, conds)
    %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
  end

  def build(original, replace_values) when is_list(replace_values) do
    sql = original
    |> String.split("?")
    |> Enum.reject(& &1 == "")
    |> Enum.zip(replace_values)
    |> Enum.map(fn {exp, val} -> "#{exp}#{convert_replace(val)}" end)
    |> Enum.join
    %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
  end

  defp generate_sql(dataset_id, table, conds) do
    [
      Select.clause(conds[:select]),
      From.clause(dataset_id, table),
      Where.clause(conds[:where]),
      Order.clause(conds[:order]),
      Limit.clause(conds[:limit])
    ]
    |> Enum.reject(& is_nil(&1))
    |> Enum.join(" ")
  end

  defp convert_replace(value) when is_bitstring(value), do: "'#{value}'"
  defp convert_replace(value), do: value
end
