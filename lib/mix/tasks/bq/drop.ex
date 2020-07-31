defmodule Mix.Tasks.Bq.Drop do
  use Mix.Task

  @shortdoc "Drop all tables from BigQuery"
  def run(_) do
    Blanton.Tables.Drop.run()
  end
end
