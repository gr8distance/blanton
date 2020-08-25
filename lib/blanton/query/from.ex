defmodule Blanton.Query.From do
  import Blanton.Utils

  def clause(dataset_id, table) do
    "FROM #{dataset_id}.#{table}"
  end

  def clause(table) do
    "FROM #{dataset_id()}.#{table}"
  end
end
