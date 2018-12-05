defmodule Rsim.StorageUploader do
  @moduledoc """
  Helper to get basic file info
  """

  alias Rsim.FileInfo
  alias Rsim.PathBuilder
  alias Rsim.ImageDownloader
  alias Rsim.Image

  @doc """
  Saves image from provided URL.

  It saves image to storage and repo. It returns ID of created image
  """
  @spec save_image_from_url(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_image_from_url(url, image_type) do
    case ImageDownloader.to_tmp_file(url) do
      {:ok, tmp_path} ->
        save_image_from_file(tmp_path, image_type)
      {:error, error} -> {:error, error}
    end
  end


  @doc """
  Saves image from provided file path.

  It saves image to storage and repo. It returns ID of created image
  """
  @spec save_image_from_file(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_image_from_file(file_path, image_type) do
    mime = FileInfo.get_mime!(file_path)
    size = FileInfo.get_size!(file_path)
    id = UUID.uuid4()

    {:ok, width, height} = Rsim.Config.meter().size(file_path)

    storage_path = PathBuilder.key_from_path(file_path, Atom.to_string(image_type), id)
    case Rsim.Config.storage().save_file(file_path, storage_path) do
      :ok ->
        image = %Image{id: id, type: Atom.to_string(image_type), path: storage_path, mime: mime, size: size,
          width: width, height: height}
        save_image_to_repo(image)
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Saves resized image for specified
  """
  @spec save_image_from_file(String.t(), Rsim.Image.t()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_resized_image(file_path, parent_image = %Image{}) do
    id = UUID.uuid4()
    size = FileInfo.get_size!(file_path)
    {:ok, width, height} = Rsim.Config.meter().size(file_path)

    storage_path = PathBuilder.key_from_path(file_path, parent_image.type, id, parent_image.id)
    case Rsim.Config.storage().save_file(file_path, storage_path) do
      :ok ->
        image = %Image{id: id, type: parent_image.type, path: storage_path, mime: parent_image.mime, size: size,
          width: width, height: height}
        save_image_to_repo(image)
      {:error, error} -> {:error, error}
    end
  end

  defp save_image_to_repo(image = %Image{}) do
    case Rsim.Config.image_repo().save(image) do
      {:ok, ecto_image} -> {:ok, Rsim.EctoImage.to_image(ecto_image)}
      {:error, error} -> {:error, error}
    end
  end
end
