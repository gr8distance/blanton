defmodule Blanton.Query.Select do
  def clause, do: "SELECT *"
  def clause(nil), do: clause()
  def clause(args) when is_bitstring(args), do: "SELECT #{args}"
  def clause(args) when is_list(args) do
    args
    |> Enum.join(", ")
    |> clause
  end
end
