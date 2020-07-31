defmodule Mix.Tasks.Bq.Migrate do
  use Mix.Task

  @shortdoc "Migrate to BigQuery"
  def run(_) do
    Blanton.Tables.Migrate.run()
  end
end
