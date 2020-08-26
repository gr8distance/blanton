defmodule Blanton.Query.Limit do
  require IEx

  @moduledoc """
  Build limit clause
  """

  @doc """
  Build limit cluase

  ## example

  iex(1)> Blanton.Query.Limit.clause
  nil
  """
  @spec clause() :: nil
  def clause(), do: nil

  @doc """
  Build limit cluase

  ## example

  iex(1)> Blanton.Query.Limit.clause
  nil
  """
  @spec clause(nil) :: nil
  def clause(nil), do: clause()

  @doc """
  Build limit cluase

  ## example

  iex(1)> Blanton.Query.Limit.clause(10)
  "LIMIT 10"
  """
  @spec clause(Integer.t()) :: String.t()
  def clause(limit), do: "LIMIT #{limit}"
end
