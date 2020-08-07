defmodule Blanton.Query.Limit do
  require IEx

  def clause(), do: ""
  def clause(limit), do: "LIMIT #{limit}"
end
