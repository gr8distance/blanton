defmodule Blanton.Query.Select do
  @moduledoc """
  Build select clause
  """

  @doc """
  build select clause

  ## example

  iex(1)> Blanton.Query.Select.clause
  "SELECT *"
  """
  @spec clause() :: String.t()
  def clause, do: "SELECT *"

  @doc """
  build select clause

  ## example

  iex(1)> Blanton.Query.Select.clause(nil)
  "SELECT *"
  """
  @spec clause(nil) :: String.t()
  def clause(nil), do: clause()

  @doc """
  build select clause

  ## example

  iex(1)> Blanton.Query.Select.clause("name")
  "SELECT name"
  """
  @spec clause(String.t()) :: String.t()
  def clause(args) when is_bitstring(args), do: "SELECT #{args}"

  @doc """
  build select clause

  ## example

  iex(1)> Blanton.Query.Select.clause(["name", "age", "role"])
  "SELECT name, age, role"
  """
  @spec clause(list()) :: String.t()
  def clause(args) when is_list(args) do
    args
    |> Enum.join(", ")
    |> clause
  end
end
