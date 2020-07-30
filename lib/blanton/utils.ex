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
  convert_upcased_string(:atom)
  "ATOM"
  """
  @spec convert_upcased_string(atom()) :: String.t()
  def convert_upcased_string(from) when is_atom(from) do
    from
    |> Atom.to_string
    |> String.upcase
  end

  @doc """
  Convert upcased String from string

  ## example
  convert_upcased_string("string")
  "STRING"
  """
  @spec convert_upcased_string(String.t()) :: String.t()
  def convert_upcased_string(from) when is_bitstring(from) do
    from |> String.upcase
  end
end
