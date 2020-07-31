defmodule Blanton.Schema do
  @moduledoc """
  Provide schema macro
  """

  import Blanton.Utils

  defmacro __using__(_) do
    quote do
      import Blanton.Schema

      @doc """
      Return column names from Table Schema

      ## example

      pry(1)> Users.column_names()

      [:__bq_admin__, :__bq_age__, :__bq_name__]
      """
      @spec column_names() :: [String.t()]
      def column_names do
        __MODULE__.__info__(:functions)
        |> Keyword.keys
        |> Enum.map(fn f -> Atom.to_string(f) end)
        |> Enum.filter(fn f -> String.match?(f, ~r/__bq_/) end)
        |> Enum.map(fn f -> String.to_atom(f) end)
      end

      @doc """
      return bq_columns

      pry(2)> Users.bq_columns()
      [
        %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
          categories: nil,
          description: nil,
          fields: nil,
          mode: "NULLABLE",
          name: "admin",
          policyTags: nil,
          type: "BOOLEAN"
        },
        %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
          categories: nil,
          description: nil,
          fields: nil,
          mode: "NULLABLE",
          name: "age",
          policyTags: nil,
          type: "INT64"
        },
        %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
          categories: nil,
          description: nil,
          fields: nil,
          mode: "REQUIRED",
          name: "name",
          policyTags: nil,
          type: "STRING"
        }
      ]
      """
      @spec bq_columns() :: [String.t()]
      def bq_columns do
        column_names()
        |> Enum.map(fn name ->
          {{:ok, column}, _} = "#{__MODULE__}.#{name}"
          |> Code.string_to_quoted
          |> Code.eval_quoted
          column
        end)
      end

      @doc """
      Return GoogleApi.BigQuery.V2.Model.Table

      ## example

      iex(1)> Users.schema()
      %GoogleApi.BigQuery.V2.Model.Table{
        clustering: nil,
        creationTime: nil,
        description: nil,
        encryptionConfiguration: nil,
        etag: nil,
        expirationTime: nil,
        externalDataConfiguration: nil,
        friendlyName: nil,
        id: nil,
        kind: nil,
        labels: nil,
        lastModifiedTime: nil,
        location: nil,
        materializedView: nil,
        model: nil,
        numBytes: nil,
        numLongTermBytes: nil,
        numPhysicalBytes: nil,
        numRows: nil,
        rangePartitioning: nil,
        requirePartitionFilter: nil,
        schema: %GoogleApi.BigQuery.V2.Model.TableSchema{
          fields: [
            %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
              categories: nil,
              description: nil,
              fields: nil,
              mode: "NULLABLE",
              name: "admin",
              policyTags: nil,
              type: "BOOLEAN"
            },
            %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
              categories: nil,
              description: nil,
              fields: nil,
              mode: "NULLABLE",
              name: "age",
              policyTags: nil,
              type: "INT64"
            },
            %GoogleApi.BigQuery.V2.Model.TableFieldSchema{
              categories: nil,
              description: nil,
              fields: nil,
              mode: "REQUIRED",
              name: "name",
              policyTags: nil,
              type: "STRING"
            }
          ]
        },
        selfLink: nil,
        snapshotDefinition: nil,
        streamingBuffer: nil,
        tableReference: %GoogleApi.BigQuery.V2.Model.TableReference{
          datasetId: "",
          projectId: "",
          tableId: "users"
        },
        timePartitioning: nil,
        type: nil,
        view: nil
      }
      """
      @spec schema() :: GoogleApi.BigQuery.V2.Model.Table.t()
      def schema do
        Blanton.Table.new(
          project_id(),
          dataset_id(),
          __table_name__(),
          bq_columns()
        )
      end
    end
  end

  defmacro schema(table, do: block) do
    quote do
      @doc """
      Return table name

      ## example

      pry(1)> Blanton.Users.__table_name__()
      :users
      """
      @spec __table_name__() :: String.t()
      def __table_name__ do
        case unquote(table) do
          t when is_bitstring(t) ->
            t
          t when is_atom(t) ->
            Atom.to_string(t)
          _ ->
            nil
        end
      end

      unquote(block)
    end
  end

  defmacro field(name, type, mode) do
    func_name = :"__bq_#{name}__"

    quote do
      def unquote(func_name)() do
        Blanton.Column.new(
          unquote(name),
          unquote(type),
          unquote(mode),
          nil
        )
      end
      def unquote(name)(), do:  unquote(func_name)()
    end
  end

  defmacro field(name, type, mode, []) do
    func_name = :"__bq_#{name}__"

    quote do
      def unquote(func_name)() do
        Blanton.Column.new(
          unquote(name),
          unquote(type),
          unquote(mode),
          nil
        )
      end
      def unquote(name)(), do:  unquote(func_name)()
    end
  end

  defmacro field(name, type, mode, fields) do
    func_name = :"__bq_#{name}__"
    quote do
      def unquote(func_name)() do
        Blanton.Column.new(
          unquote(name),
          unquote(type),
          unquote(mode),
          unquote(fields)
        )
      end
      def unquote(name)(), do:  unquote(func_name)()
    end
  end

  defmacro sub_field(name, type, mode) do
    quote do
      %{
        name: unquote(name),
        type: unquote(type),
        mode: unquote(mode)
      }
    end
  end
end
