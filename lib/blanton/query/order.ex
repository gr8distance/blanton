defmodule Blanton.Query.Order do
  require IEx

  def clause(), do: nil
  def clause(nil), do: clause()
  def clause(columns) when is_list(columns), do: Enum.join(columns, ", ")
  def clause(column), do: "#{column}"
  def clause(column, sort), do: clause(column) <> sort_rule(sort)

  def sort_rule(sort) when is_bitstring(sort), do: " #{String.upcase(sort)}"
  def sort_rule(sort) when is_atom(sort), do: sort |> Atom.to_string |> sort_rule
end
