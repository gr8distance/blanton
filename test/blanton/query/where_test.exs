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

  describe "clause" do
    test "when args is string" do
      query = "is = 10 or in (10, 30)"
      assert Where.clause(query) == "WHERE " <> query
    end

    test "when args is tupple" do
      args = [:=, :column, 10]
      assert Where.clause(args) == "WHERE column = 10"
    end
  end

  describe "to_s" do
    test "when = with string" do
      assert Where.to_s([:=, :column, "hoge"]) == "column = 'hoge'"
    end

    test "when = without string" do
      assert Where.to_s([:=, :column, 1]) == "column = 1"
    end

    test "when != with string" do
      assert Where.to_s([:!=, :column, "hoge"]) == "column != 'hoge'"
    end

    test "when != without string" do
      assert Where.to_s([:!=, :column, 1]) == "column != 1"
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
        assert Where.to_s(args) == "column #{exp} 'hoge'"
      end)
    end

    test "when in with string list" do
      assert Where.to_s([:in, :column, ["a", "b", "c"]]) == "column IN ('a', 'b', 'c')"
    end

    test "when in with number list" do
      assert Where.to_s([:in, :column, [1, 2, 3]]) == "column IN (1, 2, 3)"
    end

    test "when not in with string list" do
      assert Where.to_s([:not_in, :column, ["a", "b", "c"]]) == "column NOT IN ('a', 'b', 'c')"
    end

    test "when not in with number list" do
      assert Where.to_s([:not_in, :column, [1, 2, 3]]) == "column NOT IN (1, 2, 3)"
    end

    test "when between with string list" do
      assert Where.to_s([:between, :column, ["from", "to"]]) == "column BETWEEN 'from' AND 'to'"
    end

    test "when between without string list" do
      assert Where.to_s([:between, :column, [1, 10]]) == "column BETWEEN 1 AND 10"
    end

    test "when not between with string list" do
      assert Where.to_s([:not_between, :column, ["from", "to"]]) == "column NOT BETWEEN 'from' AND 'to'"
    end

    test "when not between without string list" do
      assert Where.to_s([:not_between, :column, [1, 10]]) == "column NOT BETWEEN 1 AND 10"
    end

    test "when like with string value" do
      assert Where.to_s([:like, :column, "%hoge"]) == "column LIKE '%hoge'"
    end

    test "when not like with string value" do
      assert Where.to_s([:not_like, :column, "%hoge"]) == "column NOT LIKE '%hoge'"
    end
  end
end
