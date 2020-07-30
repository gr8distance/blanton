defmodule Blanton.UtilsTest do
  use ExUnit.Case

  doctest Blanton.Utils

  test "project_id() return project_id from config/config.exs" do
    assert Blanton.Utils.project_id() == Application.get_env(:blanton, :project_id)
  end

  test "dataset_id() return dataset_id from config/config.exs" do
    assert Blanton.Utils.dataset_id() == Application.get_env(:blanton, :dataset_id)
  end
end
