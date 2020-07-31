defmodule Blanton.Column do
  @moduledoc """
  This module that handles columns of table schema.
  """

  import Blanton.Utils

  @doc """
  Create GoogleApi.BigQuery.V2.Model.TableFieldSchema from Listed map

  ## example
  new([
    %{name: "column1", type: :string, mode: :required},
    %{name: "column2", type: :int64, mode: :nullable},
  ])

  [
    %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "column1", type: "STRING", mode: "REQUIRED"},
    %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "column2", type: "INT64", mode: "NULLABLE"}
  ]
  """
  @spec new([Map.t()]) :: [GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()]
  def new(columns) do
    columns
    |> Enum.map(fn (c) ->
      new(
        Map.get(c, :name),
        Map.get(c, :type),
        Map.get(c, :mode),
        Map.get(c, :fields)
      )
    end)
  end

  @doc """
  Create GoogleApi.BigQuery.V2.Model.TableFieldSchema

  ## example
  new("column", :string, :required, nil)

  %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "column", type: "STRING", mode: "REQUIRED"}
  """
  @spec new(String.t(), atom(), atom(), nil) :: GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()
  def new(name, type, mode, nil) do
    %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
      name: to_s(name),
      type: convert_upcased_string(type),
      mode: convert_upcased_string(mode),
    }
  end

  @doc """
  Create GoogleApi.BigQuery.V2.Model.TableFieldSchema

  ## example
  new("column", :string, :required, [])

  %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "column", type: "STRING", mode: "REQUIRED"}
  """
  @spec new(String.t(), atom(), atom(), list()) :: GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()
  def new(name, type, mode, []), do: new(name, type, mode, nil)

  @doc """
  Create GoogleApi.BigQuery.V2.Model.TableFieldSchema

  ## example
  new("column", :string, :required, [%{name: String.t(), mode: :string, type: :nullable}])

  %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
    name: "column",
    type: "STRING",
    mode: "REQUIRED"
    fields: [
      %GoogleApi.BigQuery.V2.Model.TableFieldSchema{name: "column", type: "STRING", mode: "NULLABLE"}
    ]
  }
  """
  @spec new(String.t(), atom(), atom(), list()) :: GoogleApi.BigQuery.V2.Model.TableFieldSchema.t()
  def new(name, type, mode, fields) do
    %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
      name: to_s(name),
      type: convert_upcased_string(type),
      mode: convert_upcased_string(mode),
      fields: new(fields)
    }
  end
end
