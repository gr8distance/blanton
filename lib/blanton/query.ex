defmodule Blanton.Query do
  alias Blanton.Query.{Select, From, Where, Order, Limit}
  require IEx

  @moduledoc """
  Build select query
  """

  @doc """
  Build select query using dataset_id, table, conds

  ## example

  iex(1)> Blanton.Query.build("dataset", "table_name", where: [[:=, :name, "name"], [:in, :age, [20, 30]]], limit: 10)
  %GoogleApi.BigQuery.V2.Model.QueryRequest{
    connectionProperties: nil,
    defaultDataset: nil,
    dryRun: nil,
    kind: nil,
    labels: nil,
    location: nil,
    maxResults: nil,
    maximumBytesBilled: nil,
    parameterMode: nil,
    preserveNulls: nil,
    query: "SELECT * FROM dataset.table_name WHERE name = 'name' AND  age IN (20, 30) LIMIT 10",
    queryParameters: nil,
    requestId: nil,
    timeoutMs: nil,
    useLegacySql: nil,
    useQueryCache: nil
  }

  You can pass conds
  where, limit, order
  """
  @spec build(String.t(), String.t(), list()) :: GoogleApi.BigQuery.V2.Model.QueryRequest.t()
  def build(dataset_id, table, conds) do
    sql = generate_sql(dataset_id, table, conds)
    %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
  end

  @doc """
  Build select query using dataset_id, table, conds

  ## example

  iex(1)> Blanton.Query.build("SELECT * FROM dataset.users WHERE name = ?", ["gr8distance"])
  %GoogleApi.BigQuery.V2.Model.QueryRequest{
    connectionProperties: nil,
    defaultDataset: nil,
    dryRun: nil,
    kind: nil,
    labels: nil,
    location: nil,
    maxResults: nil,
    maximumBytesBilled: nil,
    parameterMode: nil,
    preserveNulls: nil,
    query: "SELECT * FROM dataset.users WHERE name = 'gr8distance'",
    queryParameters: nil,
    requestId: nil,
    timeoutMs: nil,
    useLegacySql: nil,
    useQueryCache: nil
  }
  """
  @spec build(String.t(), list()) :: GoogleApi.BigQuery.V2.Model.QueryRequest.t()
  def build(original, replace_values) when is_list(replace_values) do
    sql = original
    |> String.split("?")
    |> Enum.reject(& &1 == "")
    |> Enum.zip(replace_values)
    |> Enum.map(fn {exp, val} -> "#{exp}#{convert_replace(val)}" end)
    |> Enum.join
    %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
  end

  @spec generate_sql(String.t(), String.t(), list()) :: String.t()
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

  @spec convert_replace(String.t()) :: String.s()
  defp convert_replace(value) when is_bitstring(value), do: "'#{value}'"

  defp convert_replace(value), do: value
end
