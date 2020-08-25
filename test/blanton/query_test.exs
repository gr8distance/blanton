defmodule Blanton.QueryTest do
  use ExUnit.Case

  alias Blanton.Query
  doctest Blanton.Query

  require IEx

  test "build/3 return GoogleApi.BigQuery.V2.Model.QueryRequest sql" do
    dataset_id = "dataset"
    table = "users"
    conds = [
      select: "*",
      where: [
        [:=, :name, "hoge"]
      ]
    ]
    expects = "SELECT * FROM dataset.users WHERE name = 'hoge'"
    actual = Blanton.Query.build(dataset_id, table, conds)
    assert expects == actual.query
  end

  test "build/2 return GoogleApi.BigQuery.V2.Model.QueryRequest" do
    name = "hoge"
    age = 30
    worker = true
    sql = "SELECT * FROM dataset.users WHERE name = ? OR age = ? OR worker = ?"
    expects = "SELECT * FROM dataset.users WHERE name = '#{name}' OR age = #{age} OR worker = #{worker}"
    actual = Blanton.Query.build(sql, [name, age, worker])
    assert expects == actual.query
  end
end
