defmodule Blanton.Record do
  import Blanton.Connection
  import Blanton.Utils

  @moduledoc """
  Insert record to BigQuery tables
  """

  @doc """
  Insert records to table

  ## example
  Blanton.Record.insert("PROJECT_IF", "DATASET_ID", "TABLE", [%{age: 30, email: "a@example.com", name: "user"}], false, true)

  %GoogleApi.BigQuery.V2.Model.TableDataInsertAllResponse{
    insertErrors: nil,
    kind: "bigquery#tableDataInsertAllResponse"
  }
  """
  @spec insert(String.t(), String.t(), String.t(), [%{}], Booealn.t(), Boolean.t()) :: GoogleApi.BigQuery.V2.Model.TableDataInsertAllResponse.t()
  def insert(project_id, dataset_id, table, records, ignore_unknown_values, skip_invalid_rows) do
    {:ok, res} = GoogleApi.BigQuery.V2.Api.Tabledata.bigquery_tabledata_insert_all(
      connect(),
      project_id,
      dataset_id,
      table,
      [body: to_records(records, ignore_unknown_values, skip_invalid_rows)]
    )
    res
  end

  @doc """
  Insert records to table
  auto set project_id and dataset_id from config.exs

  ## example
  Blanton.Record.insert("TABLE", [%{age: 30, email: "a@example.com", name: "user"}])

  %GoogleApi.BigQuery.V2.Model.TableDataInsertAllResponse{
    insertErrors: nil,
    kind: "bigquery#tableDataInsertAllResponse"
  }
  """
  @spec insert(String.t(), [%{}], Booealn.t(), Boolean.t()) :: GoogleApi.BigQuery.V2.Model.TableDataInsertAllResponse.t()
  def insert(table, records, ignore_unknown_values \\ false, skip_invalid_rows \\ true) do
    insert(project_id(), dataset_id(), table, records, ignore_unknown_values, skip_invalid_rows)
  end

  @spec to_records([%{}], Boolean.t(), Boolean.t()) :: GoogleApi.BigQuery.V2.Model.TableDataInsertAllRequest.t()
  defp to_records(records, ignore_unknown_values, skip_invalid_rows) do
    %GoogleApi.BigQuery.V2.Model.TableDataInsertAllRequest{
      ignoreUnknownValues: ignore_unknown_values,
      skipInvalidRows: skip_invalid_rows,
      rows: rows(records)
    }
  end

  @spec rows([%{}]) :: [GoogleApi.BigQuery.V2.Model.TableDataInsertAllRequestRows.t()]
  defp rows(records) do
    records
    |> Enum.map(fn record ->
      %GoogleApi.BigQuery.V2.Model.TableDataInsertAllRequestRows{json: record}
    end)
  end
end
