defmodule Rsim.Storage do
  @moduledoc """
  Uploader Behaviour
  """

  @doc """
  Returns URL to the file in storage
  """
  @callback file_url(String.t()) :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Save file to storage
  """
  @callback save(String.t(), String.t(), Map) :: :ok | {:error, String.t()}

  @doc """
  Save file to storage
  """
  @callback save(String.t(), String.t()) :: :ok | {:error, String.t()}

  @doc """
  Delete file to storage
  """
  @callback delete(String.t(), String.t()) :: :ok | {:error, String.t()}
end
