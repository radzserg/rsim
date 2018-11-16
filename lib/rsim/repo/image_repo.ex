defmodule Rsim.ImageRepo do
  @moduledoc """
  Image Repo Behaviour
  """

  @doc """
  Save file to storage
  """
  @callback save(Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, String.t}
end