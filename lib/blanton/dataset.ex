defmodule Blanton.Dataset do
  import Blanton.Connection
  import Blanton.Utils

  @moduledoc """
  Controllable BigQuery dataset
  You can get a list, create, delete.
  """

  @doc """
  Get a dataset struct

  ## Full docs
  https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Api.Datasets.html#content
  """

  require IEx
  @spec get(String.t(), String.t(), Keyword.t(), Keyword.t()) :: GoogleApi.BigQuery.V2.Model.Dataset.t()
  def get(project_id, dataset_id, optional_params \\ [], opts \\ []) do
    {:ok, dataset} = GoogleApi.BigQuery.V2.Api.Datasets.bigquery_datasets_get(
      connect(),
      project_id,
      dataset_id,
      optional_params,
      opts
    )
    dataset
  end

  @spec get(Keyword.t(), Keyword.t()) :: GoogleApi.BigQuery.V2.Model.Dataset.t()
  def get() do
    get(project_id(), dataset_id(), [], [])
  end

  @doc """
  Get a list of the datasets that belong to the project ID
  """

  @spec lists(String.t(), Keyword.t(), Keyword.t()) :: GoogleApi.BigQuery.V2.Api.Datasets.t()
  def lists(project_id, optional_params \\ [], opts \\ []) do
    GoogleApi.BigQuery.V2.Api.Datasets.bigquery_datasets_list(
      connect(), project_id, optional_params, opts
    )
  end

  @spec lists :: GoogleApi.BigQuery.V2.Api.Datasets.t()
  def lists(), do: lists(project_id(), [], [])

  @doc """
  Create a dataset for the specified project ID
  """

  @spec create(String.t(), String.t(), Keyword.t()) :: GoogleApi.BigQuery.V2.Model.Dataset.t()
  def create(project_id, dataset_id, opts \\ []) do
    body = %GoogleApi.BigQuery.V2.Model.Dataset{
      datasetReference: %GoogleApi.BigQuery.V2.Model.DatasetReference{datasetId: dataset_id, projectId: project_id},
    }
    GoogleApi.BigQuery.V2.Api.Datasets.bigquery_datasets_insert(connect(), project_id, [body: body], opts)
  end

  @spec create(String.t()) :: GoogleApi.BigQuery.V2.Model.Dataset.t()
  def create(dataset_id), do: create(project_id(), dataset_id, [])

  @doc """
  Delete a dataset for the specified project id
  """

  @spec delete(String.t(), String.t(), Keyword.t(), Keyword.t()) :: {:ok, Tesla.Env.t()}
  def delete(project_id, dataset_id, optional_params \\ [], opts \\ []) do
    GoogleApi.BigQuery.V2.Api.Datasets.bigquery_datasets_delete(
      connect(), project_id, dataset_id, optional_params, opts
    )
  end

  @spec delete(String.t()) :: {:ok, Tesla.Env.t()}
  def delete(dataset_id), do: delete(project_id(), dataset_id)
end
