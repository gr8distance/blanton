defmodule Blanton.Query.Where do
  def parse([]), do: ""
  def parse(conds) when is_tuple(conds), do: (" WHERE" <> parse_by(conds)) |> format()
  def parse(conds) when is_list(conds), do: " WHERE #{parse_by(conds)}" |> format()

  defp parse_by({:in, column, list}) do
    l =
      list
      |> Enum.map(&convert(&1))
      |> Enum.join(", ")

    " #{column} IN (#{l})"
  end

  defp parse_by(conds) when is_list(conds) do
    Enum.map(conds, fn condition -> parse_by(condition) end)
    |> Enum.join(" AND ")
  end

  defp parse_by({k, v}), do: "#{k} = #{convert(v)}"

  defp parse_by({:between, column, from, to}) do
    " #{column} BETWEEN #{convert(from)} AND #{convert(to)}"
  end

  defp parse_by({:like, column, v}) do
    " #{column} LIKE #{convert(v)}"
  end

  defp parse_by({operator, column, v}) do
    " #{column} #{operator} #{convert(v)}"
  end

  defp convert(v) when is_number(v), do: v
  defp convert(v) when is_bitstring(v), do: "'#{v}'"
  defp convert(v), do: "#{v}"

  defp format(query) do
    query
    |> String.replace("  ", " ")
  end
end
