defmodule BlantonTest do
  use ExUnit.Case
  doctest Blanton

  test "greets the world" do
    assert Blanton.hello() == :world
  end
end
