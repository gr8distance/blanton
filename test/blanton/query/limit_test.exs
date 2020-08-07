defmodule Blanton.Query.LimitTest do
  use ExUnit.Case

  alias Blanton.Query.Limit
  doctest Blanton.Query.Limit

  require IEx

  describe "limit is" do
    test "args is nil" do
      assert Limit.clause() == ""
    end

    test "with integer" do
      assert Limit.clause(10) == "LIMIT 10"
    end
  end
end
