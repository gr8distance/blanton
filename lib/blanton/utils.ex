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
end
