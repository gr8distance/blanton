# Blanton

* Blanton is a BigQuery library written by Elixir.

## Installation

1. Add Blanton to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:blanton, "~> 0.2.2"}
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
config :blanton,
  project_id: "",
  dataset_id: ""
```

## You can do

- Dataset
  - [x] Create
  - [x] Delete
- Table
  - [x] Select
  - [x] Create
  - [x] Create(Option usable)
  - [x] Update
  - [x] Delete
- Record
  - [x] Insert
  - [x] Select

## Usage

* Find records

```elixir
Query.table("users")
|> Query.pluck(["name", "age"])
|> Query.where([age: 31])
|> Query.limit(10)
|> Query.run
|> Query.to_records
```

* You can use below

| input                                      | output                                 |
|--------------------------------------------|----------------------------------------|
| age: 16                                    | "age = 16"                             |
| name: "桜坂しずく", age: 16                | "name = '桜坂しずく' AND age = 16"     |
| {:in, :name, ["桜坂しずく", "中須かすみ"]} | "name IN ('桜坂しずく', '中須かすみ')" |
| {:between, :age, 15, 17}                   | "age BETWEEN 15 AND 17"                |
| {:like, :name, "かな%"}                    | "name LIKE 'かな%'"                    |
| {:<=, :age, 18}                            | "age <= 18"                            |
| "name = ?", "中須かすみ"                   | "name = '中須かすみ'"                  |
| "name = ? OR age > 15", ["桜坂しずく", 16] | "name = '桜坂しずく' OR age > 15"      |

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

  # options do
  #   partitiondate
  #   register :timePartitioning, %GoogleApi.BigQuery.V2.Model.TimePartitioning{type: "DAY"}
  # end
end
```


* After creating the file, run the following command.
  * `mix bq.migrate lib/bq_schema`
* If you want to delete the table use the following command
  * `mix bq.drop`
  * **Please be careful because it cannot be stopped even if you execute it by mistake.**
