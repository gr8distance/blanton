defmodule Blanton.Query.OrderTest do
  use ExUnit.Case

  alias Blanton.Query.Order
  doctest Blanton.Query.Order

  require IEx

  describe "order by" do
    test "args is nil" do
      assert Order.clause() == ""
    end

    test "args is string or atom" do
      assert Order.clause("column") == "column"
      assert Order.clause(:column) == "column"
    end

    test "args is listed string" do
      assert Order.clause(["column1", "column2"]) == "column1, column2"
    end

    test "column with sorting rules" do
      assert Order.clause("column", "desc") == "column DESC"
    end
  end
end
