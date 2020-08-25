defmodule Blanton.Query.From do
  import Blanton.Utils

  @spec clause(String.t(), String.t()) :: String.t()
  def clause(dataset_id, table), do: "FROM #{dataset_id}.#{table}"

  @spec clause(String.t()) :: String.t()
  def clause(table), do: "FROM #{dataset_id()}.#{table}"
end
