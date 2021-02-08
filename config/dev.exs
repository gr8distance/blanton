use Mix.Config

try do
  config :goth,
    json: "gcp/cred.json" |> File.read!
rescue
  _ -> :ok
end
