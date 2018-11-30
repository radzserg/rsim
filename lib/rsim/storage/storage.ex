defmodule Rsim.Storage do
  @moduledoc """
  Uploader Behaviour
  """

  @doc """
  Save file to storage
  """
  @callback save_file(String.t, String.t, Map) :: :ok | {:error, String.t}

  @doc """
  Returns URL to the file in storage
  """
  @callback file_url(String.t) :: {:ok, String.t()} | {:error, String.t}

end