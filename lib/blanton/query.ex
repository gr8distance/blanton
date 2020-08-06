defmodule Blanton.Query do

  require IEx

  # def generate_sql(dataset_id, table, conds) do
  #   from =
  #   [
  #     select_clause(conds[:select]),
  #     from_clause(dataset_id, table),
  #     where_clause(conds[:where])
  #   ]
  #   |> Enum.join(" ")
  # end
  #
  # def from_clause(dataset_id, table) do
  #   "FROM #{dataset_id}.#{table}"
  # end
  #
  # def where_clause(conds) do
  #
  # end
  #
  # def build(dataset_id, table, conds) do
  #   sql = ""
  #   %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
  # end
  #
  # def build(sql) do
  #   %GoogleApi.BigQuery.V2.Model.QueryRequest{query: sql}
  # end
end
