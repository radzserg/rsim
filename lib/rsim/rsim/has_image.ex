defmodule Rsim.HasImage do
  @moduledoc """
  Helper to get basic file info
  """

  @storage Application.get_env(:rsim, :storage)
  @repo Application.get_env(:rsim, :image_repo)

  alias Rsim.FileInfo
  alias Rsim.PathBuilder
  alias Rsim.UrlDownloader
  alias Rsim.Image

  @doc """
  Saves image from provided URL.

  It saves image to storage and repo. It returns ID of created image
  """
  @spec save_image_from_url(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_image_from_url(url, image_type) do
    case UrlDownloader.to_tmp_file(url) do
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

    storage_path = PathBuilder.key_from_path(file_path, Atom.to_string(image_type), id)

    image = %Image{id: id, type: Atom.to_string(image_type), path: storage_path, mime: mime, size: size}
    case @storage.save_file(file_path, storage_path, []) do
      :ok -> save_image_to_repo(image)
      {:error, error} -> {:error, error}
    end
  end

  defp save_image_to_repo(image = %Image{}) do
    case @repo.save(image) do
      {:ok, _ecto_image} -> {:ok, image}
      {:error, error} -> {:error, error}
    end
  end
end