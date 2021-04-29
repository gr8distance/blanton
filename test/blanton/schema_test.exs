defmodule Users do
  use Blanton.Schema

  schema :users do
    field(:name, :string, :required)
    field(:age, :int64, :nullable)
    field(:admin, :boolean, :nullable)
  end
end

defmodule Blanton.SchemaTest do
  use ExUnit.Case
  require IEx
  doctest Blanton.Schema

  test "__table_name__/0 return table names" do
    assert Users.__table_name__() == "users"
  end

  test "column_names/0 return column_names" do
    expected = [:__bq_admin__, :__bq_age__, :__bq_name__]
    assert length(Users.column_names()) == 3

    expected
    |> Enum.each(fn column ->
      assert Users.column_names() |> Enum.member?(column)
    end)
  end

  test "bq_columns/0 return [%GoogleApi.BigQuery.V2.Model.TableFieldSchema{}]" do
    assert length(Users.bq_columns()) == 3

    expected = [
      %{name: "name", type: "STRING", mode: "REQUIRED"},
      %{name: "age", type: "INT64", mode: "NULLABLE"},
      %{name: "admin", type: "BOOLEAN", mode: "NULLABLE"}
    ]

    Users.bq_columns()
    |> Enum.each(fn actual ->
      assert expected
             |> Enum.any?(fn column ->
               column.name == actual.name &&
                 column.type == actual.type &&
                 column.mode == actual.mode
             end)
    end)
  end
end
