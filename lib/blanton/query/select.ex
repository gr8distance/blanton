defmodule Blanton.Query.Select do
  def select_clause, do: "SELECT *"
  def select_clause(nil), do: select_clause()
  def select_clause(args) when is_bitstring(args), do: "SELECT #{args}"
  def select_clause(args) when is_list(args) do
    args
    |> Enum.join(", ")
    |> select_clause
  end
end
