defmodule Blanton.QueryTest do
  use ExUnit.Case

  alias Blanton.Query

  doctest Blanton.Query

  require IEx

  test ".table will return query structs set by table" do
    table = 'users'
    assert Query.table(table)[:table] == table
  end

  test ".pluck takes the map and column names and returns a map with the column names added" do
    columns = ["name", "age"]

    result =
      Query.table("users")
      |> Query.pluck(columns)

    assert result[:columns] == columns
  end

  test ".where takes map and where conds. and returns a map with the where conds added" do
    where = [name: "優木せつ菜"]

    result =
      Query.table("users")
      |> Query.where(where)

    assert result[:where] == where
  end

  test ".order takes map and column and returns a map order query added" do
    column = 'age'

    result =
      Query.table('users')
      |> Query.order(column)

    assert result[:order] == column

    order_by = [age: :desc]

    result =
      Query.table('users')
      |> Query.order(order_by)

    assert result[:order] == order_by
  end

  test ".limit takes map and integer and returns a map limit query added" do
    limit = 1

    result =
      Query.table("users")
      |> Query.limit(limit)

    assert result[:limit] == limit
  end

  test ".to_sql will return SQL from Queru structs" do
    table = "users"

    assert Query.table(table)
           |> Query.to_sql() == "SELECT * FROM users"

    columns = ["name", "age"]

    assert Query.table(table)
           |> Query.pluck(columns)
           |> Query.to_sql() == "SELECT name, age FROM users"

    where = [name: "優木せつ菜"]

    assert Query.table(table)
           |> Query.pluck(columns)
           |> Query.where(where)
           |> Query.to_sql() == "SELECT name, age FROM users WHERE name = '優木せつ菜'"

    assert Query.table(table)
           |> Query.pluck(columns)
           |> Query.where(where)
           |> Query.order("age")
           |> Query.to_sql() == "SELECT name, age FROM users WHERE name = '優木せつ菜' ORDER BY age"

    assert Query.table(table)
           |> Query.pluck(columns)
           |> Query.where(where)
           |> Query.order(["age", "name"])
           |> Query.to_sql() ==
             "SELECT name, age FROM users WHERE name = '優木せつ菜' ORDER BY age, name"

    assert Query.table(table)
           |> Query.pluck(columns)
           |> Query.where(where)
           |> Query.order(age: :DESC)
           |> Query.to_sql() ==
             "SELECT name, age FROM users WHERE name = '優木せつ菜' ORDER BY age DESC"

    assert Query.table(table)
           |> Query.pluck(columns)
           |> Query.where(where)
           |> Query.limit(10)
           |> Query.to_sql() == "SELECT name, age FROM users WHERE name = '優木せつ菜' LIMIT 10"
  end

  test ".to_records return map from Bigquery Response" do
    response = %GoogleApi.BigQuery.V2.Model.QueryResponse{
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

    expects = [
      %{
        "id" => "桜坂しずく",
        "email" => "shizuku@nijigaku.com"
      },
      %{
        "id" => "中須かすみ",
        "email" => "kasmin@nijigaku.com"
      }
    ]

    assert expects == Query.to_records(response)
  end
end
