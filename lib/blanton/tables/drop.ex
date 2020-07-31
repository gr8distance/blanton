defmodule Blanton.Tables.Drop do
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

    IO.puts "Drop all tables"
    Blanton.Table.lists()
    |> delete_all
    IO.puts "Drop suceeded!"
  end

  @spec delete_all([String.t()]) :: [Tesla.Env.t()]
  defp delete_all(tables) do
    tables
    |> Enum.each(fn table ->
      IO.puts "drop #{table}"
      delete(table)
      IO.puts "#{table} droped."
    end)
  end

  @spec delete(String.t()) :: Tesla.Env.t()
  defp delete(table) do
    Blanton.Table.delete(project_id(), dataset_id(), table)
  end
end
