defmodule Rsim.ImageRepo do
  @moduledoc """
  Image Repo Behaviour
  """

  @doc """
  Save file to storage
  """
  @callback save(Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Save file to storage with specified parent image ID
  """
  @callback save(Rsim.Image.t(), String.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Find image in repo
  """
  @callback find(String.t()) :: Rsim.Image.t() | nil

  @doc """
  Find image in repo by id width and height
  """
  @callback find(String.t(), integer(), integer()) :: Rsim.Image.t() | nil
end
