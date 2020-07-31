import Config

config :goth,
  json: "gcp/cred.json" |> File.read!

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
