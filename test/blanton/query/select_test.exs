defmodule Blanton.Query.SelectTest do
  use ExUnit.Case

  alias Blanton.Query.Select
  doctest Blanton.Query.Select

  require IEx

  describe "select_clause" do
    test "when atiry/0" do
      expects = "SELECT *"
      assert expects == Select.select_clause
    end

    test "when args is nil" do
      expects = "SELECT *"
      assert expects == Select.select_clause(nil)
    end

    test "args is string" do
      expects = "SELECT *"
      assert expects == Select.select_clause("*")
    end

    test "args is nil" do
      expects = "SELECT *"
      assert expects == Select.select_clause(nil)
    end

    test "args is list" do
      expects = "SELECT name, email"
      list = ~w{name email}
      assert expects == Select.select_clause(list)
    end
  end
end
