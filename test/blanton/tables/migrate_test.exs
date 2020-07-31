defmodule Blanton.BqSchema.Users do
  use Blanton.Schema

  schema :users do
    field :name, :string, :required
    field :age, :int64, :nullable
  end
end

require IEx

defmodule Blanton.Tables.MigrateTest do
  use ExUnit.Case

  doctest Blanton.Tables.Migrate

  test "schema_modules(mods) return all schema modules" do
    schema_modules = mods()
    |> Blanton.Tables.Migrate.schema_modules()
    assert schema_modules == [Blanton.BqSchema.Users]
  end

  defp mods() do
    [
      Blanton, Blanton.Column, Blanton.Connection, Blanton.Dataset, Blanton.Record,
      Blanton.Schema, Blanton.Table, Blanton.Tables.Drop, Blanton.Tables.Migrate,
      Blanton.Utils, Blanton.BqSchema.Users
    ]
  end
end
