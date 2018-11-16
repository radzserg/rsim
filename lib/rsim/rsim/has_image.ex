defmodule Rsim.HasImage do
  @moduledoc """
  Helper to get basic file info
  """

  @storage Application.get_env(:rsim, :storage)
  @repo Application.get_env(:rsim, :repo)

  alias Rsim.FileInfo
  alias Rsim.PathBuilder
  alias Rsim.UrlDownloader
  alias Rsim.Image

  def save_image_from_url(url, image_type) do
    {:ok, tmp_path} = UrlDownloader.to_tmp_file(url)
    mime = FileInfo.get_mime!(tmp_path)
    size = FileInfo.get_size!(tmp_path)
    id = UUID.uuid4()
    storage_path = PathBuilder.key_from_url(url, image_type, id)

    image = %Image{id: id, type: image_type, path: storage_path, mime: mime, size: size}
    case @storage.save_file(tmp_path, storage_path, []) do
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