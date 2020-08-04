defmodule Mix.Tasks.Bq.Migrate do
  use Mix.Task

  @shortdoc "Migrate to BigQuery"
  def run(args) do
    path = args |> List.first
    Blanton.Tables.Migrate.run(path)
  end
end
