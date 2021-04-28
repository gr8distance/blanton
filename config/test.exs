use Mix.Config

config :goth,
  json: "test/goth/cred.json" |> Path.expand |> File.read!
