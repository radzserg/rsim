defmodule Rsim.ImageRepo do
  @moduledoc """
  Image Repo Behaviour
  """

  @doc """
  Save file to storage
  """
  @callback save(Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Find image in repo by id
  """
  @callback find(String.t()) :: Rsim.Image.t() | nil
end