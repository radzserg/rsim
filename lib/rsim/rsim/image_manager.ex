defmodule Rsim.ImageManager do
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
  @spec save_image_from_url(url :: String.t(), image_type :: atom()) ::
          {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_image_from_url(url, image_type) do
    case ImageDownloader.to_tmp_file(url) do
      {:ok, tmp_path} ->
        save_image_from_file(tmp_path, image_type)

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Saves image from provided file path.

  It saves image to storage and repo. It returns ID of created image

  ## Examples
    {:ok, image} = Rsim.save_image_from_file("/path/to/image.jpg", :user)
    %Plug.Upload{} = uploaded_file
    {:ok, image} = Rsim.save_image_from_file(uploaded_file.path, :user, uploaded_file.filename)
  """
  @spec save_image_from_file(
          file_path :: String.t(),
          image_type :: atom(),
          filename :: String.t()
        ) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_image_from_file(file_path, image_type, filename \\ nil) do
    mime = FileInfo.get_mime!(file_path)
    size = FileInfo.get_size!(file_path)
    id = UUID.uuid4()

    {:ok, width, height} = Rsim.Config.meter().size(file_path)

    storage_path = build_storage_key(image_type, id, file_path, filename)

    case Rsim.Config.storage().save(file_path, storage_path) do
      :ok ->
        image = %Image{
          id: id,
          type: Atom.to_string(image_type),
          path: storage_path,
          mime: mime,
          size: size,
          width: width,
          height: height
        }

        save_image_to_repo(image)

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_storage_key(image_type, id, file_path, filename) when is_nil(filename),
    do: PathBuilder.key_from_path(file_path, Atom.to_string(image_type), id)

  defp build_storage_key(image_type, id, _file_path, filename),
    do: PathBuilder.key_from_path(filename, Atom.to_string(image_type), id)

  @doc """
  Saves resized image for specified

      {:ok, resized_image} = Rsim.ImageManager.save_resized_image("/path/to/image.jpg", parent_image)

  """
  @spec save_resized_image(file_path :: String.t(), parent_image :: Rsim.Image.t()) ::
          {:ok, Rsim.Image.t()} | {:ok, :atom}
  def save_resized_image(file_path, parent_image = %Image{}) do
    id = UUID.uuid4()
    size = FileInfo.get_size!(file_path)
    {:ok, width, height} = Rsim.Config.meter().size(file_path)

    storage_path =
      PathBuilder.key_from_path_with_parent(file_path, parent_image.type, id, parent_image.id)

    case Rsim.Config.storage().save(file_path, storage_path) do
      :ok ->
        image = %Image{
          id: id,
          type: parent_image.type,
          path: storage_path,
          mime: parent_image.mime,
          size: size,
          width: width,
          height: height
        }

        save_image_to_repo(image)

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Deletes image and all resized copies

      :ok =  Rsim.ImageManager.delete_image(image_id)

  """
  @spec delete_image(image_id :: String.t()) :: :ok | {:error, String.t()}
  def delete_image(image_id) when is_nil(image_id), do: :ok
  def delete_image(image_id) do
    images = Rsim.Config.image_repo().find_all_sizes_of_image(image_id)

    image_ids = Enum.map(images, & &1.id)
    image_keys = Enum.map(images, & &1.path)
    Rsim.Config.storage().delete_all(image_keys)
    Rsim.Config.image_repo().delete_all(image_ids)
    :okx
  end

  defp save_image_to_repo(image = %Image{}) do
    case Rsim.Config.image_repo().save(image) do
      {:ok, ecto_image} -> {:ok, Rsim.EctoImage.to_image(ecto_image)}
      {:error, error} -> {:error, error}
    end
  end
end
