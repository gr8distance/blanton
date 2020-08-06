defmodule Blanton.Query.Where do
  def clause() do
    ""
  end

  def clause(args) do
    args
    |> Enum.map(& to_string(&1))
    |> Enum.join(" AND ")
  end

  def to_string([:=, column, value]) when is_bitstring(value), do: "#{column} = '#{value}'"
  def to_string([:=, column, value]), do: "#{column} = #{value}"
  def to_string([:!=, column, value]) when is_bitstring(value), do: "#{column} != '#{value}'"
  def to_string([:!=, column, value]), do: "#{column} != #{value}"

  def to_string([:>, column, value]) when is_bitstring(value), do: "#{column} > '#{value}'"
  def to_string([:<, column, value]) when is_bitstring(value), do: "#{column} < '#{value}'"
  def to_string([:>=, column, value]) when is_bitstring(value), do: "#{column} >= '#{value}'"
  def to_string([:<=, column, value]) when is_bitstring(value), do: "#{column} <= '#{value}'"

  def to_string([:in, column, values]) when is_list(values), do: "#{column} IN (#{to_list_for_in_clause(values)})"
  def to_string([:not_in, column, values]) when is_list(values), do: "#{column} NOT IN (#{to_list_for_in_clause(values)})"

  def to_string([:between, column, [from, to]]) when is_bitstring(from) and is_bitstring(to), do: "#{column} BETWEEN '#{from}' AND '#{to}'"
  def to_string([:between, column, [from, to]]), do: "#{column} BETWEEN #{from} AND #{to}"

  def to_string([:not_between, column, [from, to]]) when is_bitstring(from) and is_bitstring(to), do: "#{column} NOT BETWEEN '#{from}' AND '#{to}'"
  def to_string([:not_between, column, [from, to]]), do: "#{column} NOT BETWEEN #{from} AND #{to}"

  def to_string(_), do: raise ArgumentError

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
