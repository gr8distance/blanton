defmodule Blanton.Connection do

  @moduledoc """
  Get a Google Cloud Access Token scope
  """

  @doc """
  Get a Google Cloud Access Token

  ## example

  iex(1)> Blanton.Connection.connect()

  %Tesla.Client{}
  """
  @spec connect() :: GoogleApi.BigQuery.V2.Connection.t()
  def connect do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    GoogleApi.BigQuery.V2.Connection.new(token.token)
  end
end
