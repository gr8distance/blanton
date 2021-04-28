import Config

config :blanton,
  schema_dir: "./lib/bq_schema",
  project_id: "",
  dataset_id: ""

if Mix.env == :dev do
  config :mix_test_watch,
    tasks: [
      "test",
      "dogma",
    ]
end

import_config "#{Mix.env}.exs"
