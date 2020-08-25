defmodule Blanton.Query.Order do
  require IEx

  @moduledoc """
  Build order clause
  """

  @doc """
  Build order clause

  iex(1)> Blanton.Query.Order.clause()
  nil
  """
  @spec clause() :: nil
  def clause(), do: nil

  @doc """
  Build order clause with nil

  iex(1)> Blanton.Query.Order.clause(nil)
  nil
  """
  @spec clause(nil) :: nil
  def clause(nil), do: clause()

  @doc """
  Build order clause with nil

  iex(1)> Blanton.Query.Order.clause([:a, :b])
  "ORDER BY a, b"
  """
  @spec clause(list()) :: String.t()
  def clause(columns) when is_list(columns), do: "ORDER BY #{Enum.join(columns, ", ")}"

  @doc """
  Build order clause with nil

  iex(1)> Blanton.Query.Order.clause(:column)
  "ORDER BY column"
  """
  @spec clause(Atom.t()) :: String.t()
  def clause(column), do: "ORDER BY #{column}"

  @doc """
  Build order clause with nil

  iex(1)> Blanton.Query.Order.clause("column", :desc)
  "ORDER BY column DESC"
  """
  @spec clause(Atom.t(), Atom.t()) :: String.t()
  def clause(column, sort), do: clause(column) <> sort_rule(sort)

  @spec sort_rule(String.t()) :: String.t()
  defp sort_rule(sort) when is_bitstring(sort), do: " #{String.upcase(sort)}"

  @spec sort_rule(Atom.t()) :: String.t()
  defp sort_rule(sort) when is_atom(sort), do: sort |> Atom.to_string |> sort_rule
end
