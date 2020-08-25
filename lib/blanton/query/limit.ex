defmodule Blanton.Query.Limit do
  require IEx

  def clause(), do: nil
  def clause(nil), do: clause()
  def clause(limit), do: "LIMIT #{limit}"
end
