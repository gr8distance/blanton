defmodule Blanton.Tables.Drop do
  require Logger

  @moduledoc """
  Drop all tables
  """

  import Blanton.Utils

  @doc """
  Delete all tables

  ## example

  Blanton.Table.Drop.run()

  """
  @spec run() :: [Tesla.Env.t()]
  def run() do
    verify_config!()
    load_all_deps()

    Logger.info("Drop all tables")

    Blanton.Table.lists()
    |> delete_all

    Logger.info("Drop suceeded!")
  end

  @spec delete_all([String.t()]) :: [Tesla.Env.t()]
  defp delete_all(tables) do
    tables
    |> Enum.each(fn table ->
      Logger.info("drop #{table}")
      delete(table)
      Logger.info("#{table} droped.")
    end)
  end

  @spec delete(String.t()) :: Tesla.Env.t()
  defp delete(table) do
    Blanton.Table.delete(project_id(), dataset_id(), table)
  end
end
