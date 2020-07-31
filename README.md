# Blanton

* Blanton is a BigQuery library written by Elixir.

## Installation

1. Add Blanton to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:blanton, "~> 0.1.0"}
  ]
end
```

2. Pass in your credentials json downloaded from your GCE account:

```elixir
config :goth,
  json: "path/to/google/json/creds.json" |> File.read!
```

3. If you have one dataset to operate on, you can also set it first.

```elixir
config: :blanton,
  project_id: "",
  dataset_id: ""
```

## Usage

* Create table

```elixir
columns = [
  %{name: "name", mode: :string, type: :required},
  %{name: "age", mode: :int64, type: :nullable}
]
table = Blanton.Table.new("users", columns)
Blanton.Table.create("PROJECT_ID", "DATASET_ID", table)

# if you set dataset_id and project_id to config.exs
Blanton.Table.create(table)
```

* Insert record

```elixir
records = [
  %{name: "安室透", age: 29},
  %{name: "赤井秀一", age: 32},
]
table_name = "users"
Blanton.Record.insert("PROJECT_ID", "DATASET_ID", table_name, records)

# if you set dataset_id and project_id to config.exs
Blanton.Record.insert(table_name, records)
```
