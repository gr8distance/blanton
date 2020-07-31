defmodule Blanton.Utils do
  @moduledoc """
  Frequently used functions
  """

  @doc """
  Return project id from config/config.exs
  """
  @spec project_id() :: String.t()
  def project_id, do: Application.get_env(:blanton, :project_id)

  @doc """
  Return dataset id from config/config.exs
  """
  @spec dataset_id() :: String.t()
  def dataset_id, do: Application.get_env(:blanton, :dataset_id)

  @doc """
  Convert upcased String from atom

  ## example

  iex(4)> Blanton.Utils.convert_upcased_string(:atom)
  "ATOM""
  """
  @spec convert_upcased_string(atom()) :: String.t()
  def convert_upcased_string(from) when is_atom(from) do
    from
    |> to_s
    |> String.upcase
  end

  @doc """
  Convert upcased String from string

  ## example

  iex(3)> Blanton.Utils.convert_upcased_string("string")
  "STRING"
  """
  @spec convert_upcased_string(String.t()) :: String.t()
  def convert_upcased_string(from) when is_bitstring(from) do
    from |> String.upcase
  end

  @doc """
  Convert any to string

  ## example

  iex(2)> Blanton.Utils.to_s("str")
  "str"
  """
  @spec to_s(String.t()) :: String.t()
  def to_s(from) when is_bitstring(from), do: from

  @doc """
  Convert any to string

  ## example

  iex(1)> Blanton.Utils.to_s(:atom)
  "atom"
  """
  @spec to_s(atom()) :: String.t()
  def to_s(from) when is_atom(from), do: Atom.to_string(from)
end
