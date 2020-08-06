defmodule Blanton.Query.WhereTest do
  use ExUnit.Case

  alias Blanton.Query.Where
  doctest Blanton.Query.Where

  require IEx

  describe "where" do
    test "arity 0" do
      assert Where.clause() == ""
    end
  end

  describe "to_string" do
    test "when = with string" do
      assert Where.to_string([:=, :column, "hoge"]) == "column = 'hoge'"
    end

    test "when = without string" do
      assert Where.to_string([:=, :column, 1]) == "column = 1"
    end

    test "when != with string" do
      assert Where.to_string([:!=, :column, "hoge"]) == "column != 'hoge'"
    end

    test "when != without string" do
      assert Where.to_string([:!=, :column, 1]) == "column != 1"
    end

    test "when <|>|<=|=>" do
      [
        [:<, :column, "hoge"],
        [:>, :column, "hoge"],
        [:<=, :column, "hoge"],
        [:>=, :column, "hoge"],
      ]
      |> Enum.each(fn args ->
        exp = hd(args)
        assert Where.to_string(args) == "column #{exp} 'hoge'"
      end)
    end

    test "when in with string list" do
      assert Where.to_string([:in, :column, ["a", "b", "c"]]) == "column IN ('a', 'b', 'c')"
    end

    test "when in with number list" do
      assert Where.to_string([:in, :column, [1, 2, 3]]) == "column IN (1, 2, 3)"
    end

    test "when not in with string list" do
      assert Where.to_string([:not_in, :column, ["a", "b", "c"]]) == "column NOT IN ('a', 'b', 'c')"
    end

    test "when not in with number list" do
      assert Where.to_string([:not_in, :column, [1, 2, 3]]) == "column NOT IN (1, 2, 3)"
    end

    test "when between with string list" do
      assert Where.to_string([:between, :column, ["from", "to"]]) == "column BETWEEN 'from' AND 'to'"
    end

    test "when between without string list" do
      assert Where.to_string([:between, :column, [1, 10]]) == "column BETWEEN 1 AND 10"
    end

    test "when not between with string list" do
      assert Where.to_string([:not_between, :column, ["from", "to"]]) == "column NOT BETWEEN 'from' AND 'to'"
    end

    test "when not between without string list" do
      assert Where.to_string([:not_between, :column, [1, 10]]) == "column NOT BETWEEN 1 AND 10"
    end
  end
end
