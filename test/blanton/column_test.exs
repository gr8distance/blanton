defmodule Blanton.ColumnTest do
  use ExUnit.Case

  doctest Blanton.Column

  test "new/1 return [GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()]" do
    fields = [
      %{name: "column1", type: :string, mode: :required},
      %{name: "column2", type: :int64, mode: :nullable}
    ]
    columns = Blanton.Column.new(fields)
    assert length(columns) == 2

    [column1, column2] = columns
    assert column1.name == (fields |> Enum.at(0)).name
    assert column1.type == "STRING"
    assert column1.mode == "REQUIRED"

    assert column2.name == (fields |> Enum.at(1)).name
    assert column2.type == "INT64"
    assert column2.mode == "NULLABLE"
  end

  test "new/4 | when fields is nil return GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()" do
    name = "column"
    type = :string
    mode = :required
    column = Blanton.Column.new(name, type, mode, nil)
    assert column.name == name
    assert column.type == "STRING"
    assert column.mode == "REQUIRED"
    assert column.fields == nil
  end

  test "new/4 | when fields is empty list return GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()" do
    name = "column"
    type = :string
    mode = :required
    column = Blanton.Column.new(name, type, mode, [])
    assert column.name == name
    assert column.type == "STRING"
    assert column.mode == "REQUIRED"
    assert column.fields == nil
  end

  require IEx
  test "new/4 | when fields is presented lists return GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()" do
    name = "column"
    type = :record
    mode = :repeated
    fields = [
      %{name: "column1", type: :string, mode: :required},
      %{name: "column2", type: :int64, mode: :nullable}
    ]
    column = Blanton.Column.new(name, type, mode, fields)
    assert column.name == name
    assert column.type == "RECORD"
    assert column.mode == "REPEATED"

    assert length(column.fields) == 2
    [column1, column2] = column.fields
    assert column1.name == (fields |> Enum.at(0)).name
    assert column1.type == "STRING"
    assert column1.mode == "REQUIRED"

    assert column2.name == (fields |> Enum.at(1)).name
    assert column2.type == "INT64"
    assert column2.mode == "NULLABLE"
  end
end
