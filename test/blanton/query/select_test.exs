defmodule Blanton.Query.SelectTest do
  use ExUnit.Case

  alias Blanton.Query.Select
  doctest Blanton.Query.Select

  require IEx

  describe "clause" do
    test "when atiry/0" do
      expects = "SELECT *"
      assert expects == Select.clause
    end

    test "when args is nil" do
      expects = "SELECT *"
      assert expects == Select.clause(nil)
    end

    test "args is string" do
      expects = "SELECT *"
      assert expects == Select.clause("*")
    end

    test "args is nil" do
      expects = "SELECT *"
      assert expects == Select.clause(nil)
    end

    test "args is list" do
      expects = "SELECT name, email"
      list = ~w{name email}
      assert expects == Select.clause(list)
    end
  end
end
