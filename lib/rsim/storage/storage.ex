defmodule Rsim.Storage do
  @moduledoc """
  Uploader Behaviour
  """

  @doc """
  Returns URL to the file in storage
  """
  @callback file_url(key :: String.t()) :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Save file to storage
  """
  @callback save(path :: String.t(), key :: String.t(), opts :: Map) :: :ok | {:error, String.t()}

  @doc """
  Save file to storage
  """
  @callback save(path :: String.t(), key :: String.t()) :: :ok | {:error, String.t()}

  @doc """
  Delete files from storage
  """
  @callback delete_all(image_ids :: [String.t()]) :: :ok | {:error, String.t()}
end
