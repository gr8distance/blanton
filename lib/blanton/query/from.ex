defmodule Blanton.Query.From do
  import Blanton.Utils

  def from_clause(dataset_id, table) do
    "FROM #{dataset_id}.#{table}"
  end

  def from_clause(table) do
    "FROM #{dataset_id()}.#{table}"
  end
end
