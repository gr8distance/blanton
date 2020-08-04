# Blanton

* Blanton is a BigQuery library written by Elixir.

## Installation

1. Add Blanton to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:blanton, "~> 0.1.2"}
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

## You can do

- Dataset
  - [x] Create
  - [x] Delete
- Table
  - [x] Create
  - [x] Create(Option usable)
  - [x] Update
  - [x] Delete
- Record
  - [x] Insert

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

* Create migration file

```elixir
# lib/APP_NAME/bq_schema/TABLE_NAME.ex

defmodule APP_NAME.BqSchema.TABLE_NAME do
  use Blanton.Schema

  schema :TABLE_NAME do
    field :column_name, :string, :required
    field :some_field_column, :record, :repeated, [
      sub_field(:name, :string, :nullable),
      sub_field(:price, :int64, :nullable),
    ]
  end
end
```

* After creating the file, run the following command.
  * `mix bq.migrate`
* If you want to delete the table use the following command
  * `mix bq.drop`
  * **Please be careful because it cannot be stopped even if you execute it by mistake.**
