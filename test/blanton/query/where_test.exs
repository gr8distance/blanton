defmodule Blanton.Query.WhereTest do
  require IEx
  use ExUnit.Case

  alias Blanton.Query.Where

  doctest Blanton.Query.Where

  test "when []" do
    assert Where.parse([]) == ""
  end

  test "when [key: value]" do
    assert Where.parse(name: "桜坂しずく") == " WHERE name = '桜坂しずく'"
  end

  test "when [k1: v1, k2: v2]" do
    assert Where.parse(name: "桜坂しずく", song: "あなたの理想のヒロイン") ==
             " WHERE name = '桜坂しずく' AND song = 'あなたの理想のヒロイン'"
  end

  test "when {:in, key, list}" do
    assert Where.parse({:in, :name, ["桜坂しずく", "中須かすみ"]}) == " WHERE name IN ('桜坂しずく', '中須かすみ')"
  end

  test "when {:between, key, from, to}" do
    assert Where.parse({:between, :age, 16, 17}) == " WHERE age BETWEEN 16 AND 17"
  end

  test "when {:like, key, value}" do
    assert Where.parse({:like, :name, "%か"}) == " WHERE name LIKE '%か'"
  end

  test "when {operator, key, v}" do
    assert Where.parse({:=, :age, 16}) == " WHERE age = 16"
    assert Where.parse({:<=, :age, 17}) == " WHERE age <= 17"
    assert Where.parse({:<, :age, 18}) == " WHERE age < 18"
    assert Where.parse({:>, :age, 19}) == " WHERE age > 19"
    assert Where.parse({:>=, :age, 20}) == " WHERE age >= 20"
  end

  test "multiple conditions" do
    assert Where.parse([
             {:in, :name, ["桜坂しずく", "優木せつ菜", "近江彼方"]},
             {:between, :age, 16, 17}
           ]) == " WHERE name IN ('桜坂しずく', '優木せつ菜', '近江彼方') AND age BETWEEN 16 AND 17"
  end

  test "when passing boolean" do
    assert Where.parse(leader: true) == " WHERE leader = true"
    assert Where.parse(leader: false) == " WHERE leader = false"
  end

  test "when passing string" do
    assert Where.parse("name = '優木せつ菜'") == " WHERE name = '優木せつ菜'"
  end

  test "when passing string with list" do
    assert Where.parse("name = ?", "中須かすみ") == " WHERE name = '中須かすみ'"

    assert Where.parse("name = ? OR age > ?", ["中須かすみ", 15]) ==
             " WHERE name = '中須かすみ' OR age > 15"
  end
end
