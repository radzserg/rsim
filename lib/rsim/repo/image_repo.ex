defmodule Rsim.ImageRepo do
  @moduledoc """
  Image Repo Behaviour
  """

  @doc """
  Save file to storage
  """
  @callback save(image :: Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Save file to storage with specified parent image ID
  """
  @callback save(image :: Rsim.Image.t(), String.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Find image in repo
  """
  @callback find(image_id :: String.t()) :: Rsim.Image.t() | nil

  @doc """
  Find image in repo by id width and height
  """
  @callback find(image_id :: String.t(), width :: integer(), height :: integer()) ::
              Rsim.Image.t() | nil

  @doc """
  Find all sizes for provided image ID
  """
  @callback find_all_sizes_of_image(image_id :: integer()) :: [Rsim.Image.t()]

  @doc """
  Deletes all images by provided IDs
  """
  @callback delete_all(image_ids :: [String.t()]) :: :ok | {:error, String.t()}
end
