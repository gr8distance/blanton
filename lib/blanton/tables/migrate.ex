defmodule Blanton.Tables.Migrate do
  import Blanton.Utils

  require IEx

  @doc """
  Migrate all tables.
  Create the table if it doesn't exist, or update the schema if it already exists.

  run("lib/bq_schema")

  :ok
  """
  @spec run(String.t()) :: :ok
  def run(path) do
    verify_config!()
    load_all_deps()

    existing_tables = Blanton.Table.lists()
    IO.puts "Start migration!"

    {:ok, files} = File.ls(path)
    files
    |> to_schema(path)
    |> migrate_all!(existing_tables)
    IO.puts "All migration is succeeded!"
  end

  defp migrate_all!(modules, existing_tables) do
    modules
    |> Enum.each(fn mod ->
      table_name = mod.__table_name__()
      if Enum.member?(existing_tables, table_name) do
        update!(mod, table_name)
      else
        migrate!(mod)
      end
    end)
  end

  defp migrate!(module) do
    IO.puts "--- migrate #{module.__table_name__} ---"
    Blanton.Table.create(
      project_id(),
      dataset_id(),
      module.schema()
    )
    IO.puts "--- #{module.__table_name__} migrated.---"
  end

  defp update!(module, table_name) do
    IO.puts ">>> update #{module.__table_name__} <<<"
    Blanton.Table.update(
      table_name,
      module.schema()
    )
    IO.puts "--- #{module.__table_name__} updated. ---"
  end

  def to_schema(files, path) do
    files
    |> Enum.map(fn file ->
      {module, _} = "#{path}/#{file}"
      |> Code.require_file
      |> List.first
      module
    end)
  end
end
