defmodule Blanton.Query.FromTest do
  use ExUnit.Case

  alias Blanton.Query.From
  doctest Blanton.Query.From

  require IEx

  describe "from" do
    test "when dataset_id, table" do
      expects = "FROM dataset.table"
      assert expects == From.from_clause("dataset", "table")
    end

    test "when table" do
      expects = "FROM .table"
      assert expects == From.from_clause("table")
    end
  end
end
