defmodule Rsim.Storage do
  @moduledoc """
  Uploader Behaviour
  """

  @doc """
  Save file to storage
  """
  @callback save_file(String.t, String.t, Map) :: :ok | {:error, String.t}
end