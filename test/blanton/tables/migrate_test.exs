defmodule Blanton.BqSchema.Users do
  use Blanton.Schema

  schema :users do
    field(:name, :string, :required)
    field(:age, :int64, :nullable)
  end
end

require IEx

defmodule Blanton.Tables.MigrateTest do
  use ExUnit.Case

  doctest Blanton.Tables.Migrate
end
