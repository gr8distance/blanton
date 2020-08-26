defmodule Blanton.Query.Where do
  @moduledoc """
  Build where clause
  """

  @spec clause() :: nil
  def clause(), do: nil

  @spec clause(String.t()) :: String.t()
  def clause(args) when is_bitstring(args), do: "WHERE " <> args


  def clause(args) when is_tuple(args) do
    {exp, values} = args
    values
    |> Enum.map(fn value -> to_s(value) end)
    |> Enum.join(" #{exp |> Atom.to_string |> String.upcase}")
  end

  def clause([exp, column, value]) when is_atom(exp), do: "WHERE " <> to_s([exp, column, value])

  require IEx

  def clause(args) when is_list(args) do
    conds = args
    |> Enum.map(& clause(&1))
    |> Enum.flat_map(& String.split(&1, "WHERE"))
    |> Enum.reject(& &1 == "")
    |> Enum.join(" AND ")
    "WHERE" <> conds
  end

  def to_s([:=, column, value]) when is_bitstring(value), do: "#{column} = '#{value}'"
  def to_s([:=, column, value]), do: "#{column} = #{value}"
  def to_s([:!=, column, value]) when is_bitstring(value), do: "#{column} != '#{value}'"
  def to_s([:!=, column, value]), do: "#{column} != #{value}"

  def to_s([:>, column, value]) when is_bitstring(value), do: "#{column} > '#{value}'"
  def to_s([:<, column, value]) when is_bitstring(value), do: "#{column} < '#{value}'"
  def to_s([:>=, column, value]) when is_bitstring(value), do: "#{column} >= '#{value}'"
  def to_s([:<=, column, value]) when is_bitstring(value), do: "#{column} <= '#{value}'"

  def to_s([:in, column, values]) when is_list(values), do: "#{column} IN (#{to_list_for_in_clause(values)})"
  def to_s([:not_in, column, values]) when is_list(values), do: "#{column} NOT IN (#{to_list_for_in_clause(values)})"

  def to_s([:between, column, [from, to]]) when is_bitstring(from) and is_bitstring(to), do: "#{column} BETWEEN '#{from}' AND '#{to}'"
  def to_s([:between, column, [from, to]]), do: "#{column} BETWEEN #{from} AND #{to}"
  def to_s([:not_between, column, [from, to]]) when is_bitstring(from) and is_bitstring(to), do: "#{column} NOT BETWEEN '#{from}' AND '#{to}'"
  def to_s([:not_between, column, [from, to]]), do: "#{column} NOT BETWEEN #{from} AND #{to}"

  def to_s([:like, column, value]) when is_bitstring(value), do: "#{column} LIKE '#{value}'"
  def to_s([:like, column, value]), do: "#{column} LIKE #{value}"
  def to_s([:not_like, column, value]) when is_bitstring(value), do: "#{column} NOT LIKE '#{value}'"
  def to_s([:not_like, column, value]), do: "#{column} NOT LIKE #{value}"

  def to_s(_), do: raise ArgumentError

  defp to_list_for_in_clause([head|tail]) when is_bitstring(head) do
    ([head] ++ tail)
    |> Enum.map(& "'#{&1}'")
    |> Enum.join(", ")
  end
  defp to_list_for_in_clause(list) do
    list
    |> Enum.map(& "#{&1}")
    |> Enum.join(", ")
  end
end
