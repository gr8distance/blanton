defmodule Blanton.Query do
  @moduledoc """
  This module searches records

  Usage

  Query.table("users")
  |> Query.pluck(["name", "age"])
  |> Query.where([age: 31])
  |> Query.limit(10)
  |> Query.run
  |> Query.to_records
  """

  import Blanton.Connection

  alias Blanton.Query.Where

  require IEx

  @doc """
  Returns the Map to use when searching

  ## example
  table("users")

  iex(5)>  Query.table("users")
  %{table: "users"}
  """
  @spec table(String.t()) :: Map.t()
  def table(table), do: %{table: table}

  @doc """
  Return the Map for query building.

  ## example
  iex(3)> Blanton.Query.pluck(%{}, ["name", "age"])

  %{columns: ["name", "age"]}
  """
  @spec pluck(Map.t(), String.t()) :: Map.t()
  def pluck(map, columns), do: Map.merge(map, %{columns: columns})

  @doc """
  Return the Map for query building.
  ## example
  iex(6)> Blanton.Query.where(%{}, [name: "優木せつ菜"])

  %{where: [name: "優木せつ菜"]}
  """
  @spec where(Map.t(), String.t()) :: Map.t()
  def where(map, where), do: Map.merge(map, %{where: where})

  @doc """
  Return the Map for query building.

  ## example
  iex(1)> Blanton.Query.order(%{}, "age")
  %{order: "age"}

  iex(2)> Blanton.Query.order(%{}, ["age", "name"])
  %{order: ["age", "name"]}

  iex(3)> Blanton.Query.order(%{}, [age: :DESC])
  %{order: [age: :DESC]}
  """
  @spec limit(Map.t(), String.t()) :: Map.t()
  def order(map, order), do: Map.merge(map, %{order: order})

  @doc """
  Return the Map for query building.

  ## example
  iex(4)> Blanton.Query.limit(%{}, 10)
  %{limit: 10}
  """
  @spec limit(Map.t(), integer) :: Map.t()
  def limit(map, limit), do: Map.merge(map, %{limit: limit})

  @doc """
  Create SQL from Map

  ## example
  iex(1)> Blanton.Query.table("users") |> Blanton.Query.pluck(["name", "age"])  |> Blanton.Query.where([age: 31])  |> Blanton.Query.limit(10)  |> Blanton.Query.to_sql

  SELECT name, age FROM users WHERE age == '31' LIMIT 10""
  """
  def to_sql(map) do
    columns =
      (map[:columns] || ["*"])
      |> Enum.join(", ")

    where =
      (map[:where] || [])
      |> Where.parse()

    order =
      (map[:order] || [])
      |> parse_order

    limit =
      (map[:limit] || [])
      |> parse_limit

    "SELECT #{columns} FROM #{map[:table]}#{where}#{order}#{limit}"
  end

  def run(map, project_id \\ Application.get_env(:blanton, :project_id)) do
    sql = to_sql(map)

    {:ok, response} =
      GoogleApi.BigQuery.V2.Api.Jobs.bigquery_jobs_query(
        connect(),
        project_id,
        body: %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
      )

    response
  end

  @doc """
  Extract records from Bigquery API response

  ## example
  iex(1)>
  %GoogleApi.BigQuery.V2.Model.QueryResponse{
    rows: [
      %GoogleApi.BigQuery.V2.Model.TableRow{
        f: [
          %GoogleApi.BigQuery.V2.Model.TableCell{v: "桜坂しずく"},
          %GoogleApi.BigQuery.V2.Model.TableCell{v: "shizuku@nijigaku.com"}
        ]
      },
      %GoogleApi.BigQuery.V2.Model.TableRow{
        f: [
          %GoogleApi.BigQuery.V2.Model.TableCell{v: "中須かすみ"},
          %GoogleApi.BigQuery.V2.Model.TableCell{v: "kasmin@nijigaku.com"}
        ]
      }
    ],
    schema: %GoogleApi.BigQuery.V2.Model.TableSchema{
      fields: [
        %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "id"},
        %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "email"}
      ]
    }
  }
  |> Blanton.Query.to_records()

  [
    %{"email" => "shizuku@nijigaku.com", "id" => "桜坂しずく"},
    %{"email" => "kasmin@nijigaku.com", "id" => "中須かすみ"}
  ]
  """
  def to_records(response) do
    columns = extract_columns(response)

    response.rows
    |> Enum.map(fn row -> row.f |> Enum.map(& &1.v) end)
    |> Enum.map(fn row -> columns |> Enum.zip(row) |> Enum.into(%{}) end)
  end

  defp extract_columns(response), do: response.schema.fields |> Enum.map(& &1.name)

  defp parse_where([]), do: ""

  defp parse_where(kw) do
    conds =
      Enum.map(kw, fn {k, v} -> "#{k} == '#{v}'" end)
      |> Enum.join(" AND ")

    " WHERE #{conds}"
  end

  defp parse_order([]), do: ""
  defp parse_order(column) when is_bitstring(column), do: " ORDER BY #{column}"
  defp parse_order([{k, v}]), do: " ORDER BY #{k} #{v}"
  defp parse_order(columns) when is_list(columns), do: " ORDER BY #{Enum.join(columns, ", ")}"

  defp parse_limit([]), do: ""
  defp parse_limit(limit), do: " LIMIT #{limit}"
end
