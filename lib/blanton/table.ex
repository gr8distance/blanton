defmodule Blanton.Table do
  @moduledoc """
  Handles BigQuery table schema.
  """

  import Blanton.Utils
  import Blanton.Connection
  alias Blanton.Column

  @doc """
  Get table structs

  ## example
  get("PROJECT_ID", "DATASET_ID", "TABLE_ID")

  %GoogleApi.BigQuery.V2.Model.Table{}
  """
  @spec get(String.t(), String.t(), String.t()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def get(project_id, dataset_id, table_id) do
    {:ok, res} = GoogleApi.BigQuery.V2.Api.Tables.bigquery_tables_get(
      connect(), project_id, dataset_id, table_id
    )
    res
  end

  @spec get(String.t()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def get(table_id), do: get(project_id(), dataset_id(), table_id)

  @doc """
  Get table schema

  ## example

  schema("PROJECT_ID", "DATASET_ID", "TABLE_ID")

  [%GoogleApi.BigQuery.V2.Model.TableFieldSchema{}]
  """
  @spec schema(String.t(), String.t(), String.t()) :: [GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()]
  def schema(project_id, dataset_id, table_id) do
    res = get(project_id, dataset_id, table_id)
    res.schema.fields
  end

  @spec schema(String.t()) :: [GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()]
  def schema(table_id), do: schema(project_id(), dataset_id(), table_id)

  @doc """
  Get table lists

  ## example

  lists("PROJECT_ID", "DATASET_ID")

  ["table_a", "table_b"]
  """
  @spec lists(String.t(), String.t()) :: [String.t()]
  def lists(project_id, dataset_id) do
    {:ok, res} = GoogleApi.BigQuery.V2.Api.Tables.bigquery_tables_list(connect(), project_id, dataset_id)
    extract_table_names(res.tables)
  end

  defp extract_table_names(nil), do: []
  defp extract_table_names(tables) do
    Enum.map(tables, fn table ->
      table.tableReference.tableId
    end)
  end

  @doc """
  Get table lists using config.exs

  ## example

  lists()

  ["table_a", "table_b"]
  """
  @spec lists() :: [String.t()]
  def lists(), do: lists(project_id(), dataset_id())

  @doc """
  Create new table

  ## example

  create("PROJECT_ID", "DATASET_ID", table)

  %GoogleApi.BigQuery.V2.Model.Table{}
  """
  @spec create(String.t(), String.t(), Table.t()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def create(project_id, dataset_id, table) do
    {:ok, res} = GoogleApi.BigQuery.V2.Api.Tables.bigquery_tables_insert(
      connect(),
      project_id,
      dataset_id,
      [body: table],
      []
    )
    res
  end

  @doc """
  create new table

  ## example

  create(table)

  %GoogleApi.BigQuery.V2.Model.Table{}
  """
  @spec create(Table.t()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def create(table) do
    create(project_id(), dataset_id(), table)
  end

  @doc """
  create new table

  ## example

  create(
    "table_name",
    [
      %{name: "column", type: :string, mode: :required},
    ]
  ) :: GoogleApi.BigQuery.V2.Model.Table.t()

  %GoogleApi.BigQuery.V2.Model.Table{}
  """
  @spec create(String.t(), list()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def create(table_name, columns) do
    new(table_name, columns) |> create
  end

  @doc """
  create new table struct

  ## example

  iex(1)> Blanton.Table.new("PROJECT_ID", "DATASET_ID", "TABLE_NAME", [%{name: "column", type: :string, mode: :required}])
  %GoogleApi.BigQuery.V2.Model.Table{
    clustering: nil,
    creationTime: nil,
    description: nil,
    encryptionConfiguration: nil,
    etag: nil,
    expirationTime: nil,
    externalDataConfiguration: nil,
    friendlyName: nil,
    id: nil,
    kind: nil,
    labels: nil,
    lastModifiedTime: nil,
    location: nil,
    materializedView: nil,
    model: nil,
    numBytes: nil,
    numLongTermBytes: nil,
    numPhysicalBytes: nil,
    numRows: nil,
    rangePartitioning: nil,
    requirePartitionFilter: nil,
    schema: %GoogleApi.BigQuery.V2.Model.TableSchema{
      fields: [%GoogleApi.BigQuery.V2.Model.TableFieldSchema{mode: "REQUIRED", name: "column", type: "STRING"}]
  },
    selfLink: nil,
    snapshotDefinition: nil,
    streamingBuffer: nil,
    tableReference: %GoogleApi.BigQuery.V2.Model.TableReference{
      datasetId: "DATASET_ID",
      projectId: "PROJECT_ID",
      tableId: "TABLE_NAME"
  },
    timePartitioning: nil,
    type: nil,
    view: nil
  }
  """
  @spec new(String.t(), String.t(), String.t(), list()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def new(project_id, dataset_id, name, columns) do
    %GoogleApi.BigQuery.V2.Model.Table{
      tableReference: reference_new(project_id, dataset_id, name),
      schema: %GoogleApi.BigQuery.V2.Model.TableSchema{
        fields: Column.new(columns)
      }
    }
  end

  @doc """
  create new GoogleApi.BigQuery.V2.Model.Table

  ## example

  iex(1)> Blanton.Table.new("TABLE_NAME", [%{name: "column", type: :string, mode: :required}])
  %GoogleApi.BigQuery.V2.Model.Table{
    clustering: nil,
    creationTime: nil,
    description: nil,
    encryptionConfiguration: nil,
    etag: nil,
    expirationTime: nil,
    externalDataConfiguration: nil,
    friendlyName: nil,
    id: nil,
    kind: nil,
    labels: nil,
    lastModifiedTime: nil,
    location: nil,
    materializedView: nil,
    model: nil,
    numBytes: nil,
    numLongTermBytes: nil,
    numPhysicalBytes: nil,
    numRows: nil,
    rangePartitioning: nil,
    requirePartitionFilter: nil,
    schema: %GoogleApi.BigQuery.V2.Model.TableSchema{
      fields: [%GoogleApi.BigQuery.V2.Model.TableFieldSchema{mode: "REQUIRED", name: "column", type: "STRING"}]
  },
    selfLink: nil,
    snapshotDefinition: nil,
    streamingBuffer: nil,
    tableReference: %GoogleApi.BigQuery.V2.Model.TableReference{
      datasetId: "",
      projectId: "",
      tableId: "TABLE_NAME"
  },
    timePartitioning: nil,
    type: nil,
    view: nil
  }
  """
  @spec new(String.t(), list()) :: GoogleApi.BigQuery.V2.Model.Table.t()
  def new(name, columns) do
    new(project_id(), dataset_id(), name, columns)
  end

  @spec reference_new(String.t(), String.t(), String.t()) :: GoogleApi.BigQuery.V2.Model.TableReference.t()
  defp reference_new(project_id, dataset_id, name) do
    %GoogleApi.BigQuery.V2.Model.TableReference{
      datasetId: dataset_id,
      projectId: project_id,
      tableId: name
    }
  end

  @doc """
  Update table schema

  update("PROJECT_ID", "DATASET_ID", "TABLE_NAME", Table.new())
  """
  @spec update(String.t(), String.t(), String.t(), Table.t()) :: GoogleApi.BigQuery.V2.Model.TableRefence.t()
  def update(project_id, dataset_id, table_id, table) do
    {:ok, res} = GoogleApi.BigQuery.V2.Api.Tables.bigquery_tables_update(
      connect(),
      project_id,
      dataset_id,
      table_id,
      [body: table],
      []
    )
    res
  end

  @doc """
  Update table schema

  update("TABLE_NAME", Table.new())
  """
  @spec update(String.t(), Table.t()) :: GoogleApi.BigQuery.V2.Model.TableRefence.t()
  def update(table_id, table), do:  update(project_id(), dataset_id(), table_id, table)

  @doc """
  delete specific Table

  ## example

  delete("PROJECT_ID", "DATASET_ID", "TABLE")

  Tesla.Env.t()
  """
  @spec delete(String.t(), String.t(), String.t()) :: Tesla.Env.t()
  def delete(project_id, dataset_id, table_name) do
    {:ok, res} = GoogleApi.BigQuery.V2.Api.Tables.bigquery_tables_delete(
      connect(),
      project_id,
      dataset_id,
      table_name
    )
    res
  end
end
