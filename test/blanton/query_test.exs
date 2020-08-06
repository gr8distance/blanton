defmodule Blanton.QueryTest do
  use ExUnit.Case

  alias Blanton.Query
  doctest Blanton.Query

  require IEx


  # test "generate_sql/3 generate sql" do
  #   dataset_id = "dataset"
  #   table = "users"
  #   conds = [
  #     select: "*",
  #     where: [
  #       [:=, :name, "hoge"]
  #     ]
  #   ]
  #
  #   expects = "SELECT * FROM dataset.users WHERE name = 'hoge'"
  #   assert expects == Blanton.Query.generate_sql(dataset_id, table, conds)
  # end

  # test "build/1 return GoogleApi.BigQuery.V2.Model.QueryRequest" do
  #   sql = "SELECT * FROM dataset.users"
  #   query = Blanton.Query.build(sql)
  #   assert query.query == sql
  # end
end
