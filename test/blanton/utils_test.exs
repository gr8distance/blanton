defmodule Blanton.UtilsTest do
  use ExUnit.Case

  doctest Blanton.Utils

  test "project_id() return project_id from config/config.exs" do
    assert Blanton.Utils.project_id() == Application.get_env(:blanton, :project_id)
  end

  test "dataset_id() return dataset_id from config/config.exs" do
    assert Blanton.Utils.dataset_id() == Application.get_env(:blanton, :dataset_id)
  end

  test "convert_upcased_string(atom) return upcased string" do
    assert Blanton.Utils.convert_upcased_string(:atom) == "ATOM"
  end

  test "convert_upcased_string(string) return upcased string" do
    assert Blanton.Utils.convert_upcased_string("string") == "STRING"
  end

  test "to_string/1 convert any to string" do
    assert Blanton.Utils.to_s("hoge") == "hoge"
    assert Blanton.Utils.to_s(:hoge) == "hoge"
  end
end
