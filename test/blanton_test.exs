defmodule BlantonTest do
  use ExUnit.Case

  test "version" do
    assert Blanton.version() == "0.2.2"
  end
end
