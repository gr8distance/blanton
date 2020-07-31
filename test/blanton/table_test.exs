defmodule Blanton.TableTest do
  use ExUnit.Case

  doctest Blanton.Table

  require IEx
  test "new/4 return %GoogleApi.BigQuery.V2.Model.Table{}" do
    project_id = "project_id"
    dataset_id = "dataset_id"
    table_name = "table"
    columns = [
      %{name: "column1", type: :string, mode: :required},
      %{name: "column2", type: :int64, mode: :nullable},
    ]
    table = Blanton.Table.new(project_id, dataset_id, table_name, columns)
    assert table.tableReference.projectId == project_id
    assert table.tableReference.datasetId == dataset_id
    assert table.tableReference.tableId == table_name

    column1 = table.schema.fields |> Enum.at(0)
    assert column1.name == "column1"
    assert column1.type == "STRING"
    assert column1.mode == "REQUIRED"

    column2 = table.schema.fields |> Enum.at(1)
    assert column2.name == "column2"
    assert column2.type == "INT64"
    assert column2.mode == "NULLABLE"
  end
end
