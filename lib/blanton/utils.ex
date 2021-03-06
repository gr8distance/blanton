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
  "ATOM"
  """
  @spec convert_upcased_string(atom()) :: String.t()
  def convert_upcased_string(from) when is_atom(from) do
    from
    |> to_s
    |> String.upcase()
  end

  @spec convert_upcased_string(String.t()) :: String.t()
  def convert_upcased_string(from) when is_bitstring(from) do
    from |> String.upcase()
  end

  @doc """
  Convert any to string

  ## example

  iex(2)> Blanton.Utils.to_s("str")
  "str"
  """
  @spec to_s(String.t()) :: String.t()
  def to_s(from) when is_bitstring(from), do: from

  @spec to_s(atom()) :: String.t()
  def to_s(from) when is_atom(from), do: Atom.to_string(from)

  @spec load_all_deps() :: list()
  def load_all_deps, do: Enum.each(standard_deps(), fn dep -> load_deps(dep) end)

  @spec standard_deps() :: [atom()]
  defp standard_deps, do: [:goth, :blanton]

  @spec load_deps(atom()) :: {:ok, []}
  defp load_deps(dep), do: Application.ensure_all_started(dep)

  @spec verify_config!() :: Boolean.t()
  def verify_config!() do
    unless has_project_id?() && has_dataset_id?() do
      raise RuntimeError,
        message:
          "Either the project ID, the dataset ID, or both are not set.\nPlease check config/config.exs"
    end
  end

  defp has_project_id?, do: project_id() != "" && project_id() != nil
  defp has_dataset_id?, do: dataset_id() != "" && dataset_id() != nil
end
