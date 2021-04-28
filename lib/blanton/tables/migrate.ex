defmodule Blanton.Tables.Migrate do
  import Blanton.Utils

  require Logger
  require IEx

  @doc """
  Migrate all tables.
  Create the table if it doesn't exist, or update the schema if it already exists.

  run()

  :ok
  """
  @spec run(String.t()) :: :ok
  def run(path \\ "./lib/bq_schema") do
    verify_config!()
    load_all_deps()

    existing_tables = Blanton.Table.lists()
    Logger.info("Start migration!")

    {:ok, files} = File.ls(path)

    files
    |> to_schema(path)
    |> migrate_all!(existing_tables)

    Logger.info("All migration is succeeded!")
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
    Logger.info("--- migrate #{module.__table_name__} ---")

    Blanton.Table.create(
      project_id(),
      dataset_id(),
      module.schema()
    )

    Logger.info("--- #{module.__table_name__} migrated.---")
  end

  defp update!(module, table_name) do
    Logger.info(">>> update #{module.__table_name__} <<<")

    Blanton.Table.update(
      table_name,
      module.schema()
    )

    Logger.info("--- #{module.__table_name__} updated. ---")
  end

  def to_schema(files, path) do
    files
    |> Enum.map(fn file ->
      {module, _} =
        "#{path}/#{file}"
        |> Code.require_file()
        |> List.first()

      module
    end)
  end

  # @doc """
  # return bq_migration modules
  #
  # ## example
  #
  # Blanton.Tables.Migrate.schema_modules([
  #   Blanton.Tables.Drop, Blanton.Tables.Migrate,
  #   Blanton.Utils, Blanton.BqSchema.Users
  # ])
  # [Blanton.BqSchema.Users]
  # """
  # @spec schema_modules([atom()]) :: [atom()]
  # def schema_modules(all_modules) do
  #   all_modules
  #   |> Enum.map(fn mod -> Atom.to_string(mod) end)
  #   |> Enum.filter(fn mod -> String.match?(mod, ~r/.BqSchema./) end)
  #   |> Enum.map(fn mod -> String.to_atom(mod) end)
  # end
  #
  # @spec all_modules() :: [atom()]
  # defp all_modules() do
  #   {:ok, modules} = :application.get_key(:blanton, :modules)
  #   modules
  # end
end
