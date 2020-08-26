defmodule Blanton.Query.From do
  import Blanton.Utils

  @moduledoc """
  Build From clause
  """

  @doc """
  Build from clause

  ## example

  iex(1)> Blanton.Query.From.clause("dataset_id", "table")

  "FROM dataset_id.table_id""
  """

  @spec clause(String.t(), String.t()) :: String.t()
  def clause(dataset_id, table), do: "FROM #{dataset_id}.#{table}"

  @doc """
  Build from clause

  ## example

  > Blanton.Query.From.clause("table")
  "FROM dataset_id.table_id""
  """
  @spec clause(String.t()) :: String.t()
  def clause(table), do: "FROM #{dataset_id()}.#{table}"
end
