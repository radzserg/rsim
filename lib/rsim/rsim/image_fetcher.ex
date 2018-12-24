defmodule Rsim.ImageFetcher do
  alias Rsim.Image
  alias Rsim.ImageDownloader
  alias Rsim.PathBuilder

  @doc """
  Returns image url for provided Rsim.Image
  {:ok, image_url} = Rsim.ImageFetcher.get_image_url(image)
  """
  @spec get_image_url(Rsim.Image.t) :: {:ok, String.t} | {:error, String.t}
  def get_image_url(image = %Image{}) do
    Rsim.Config.storage().file_url(image.path)
  end

  @doc """
  Returns image url for provided Rsim.Image ID
  {:ok, image_url} = Rsim.ImageFetcher.get_image_url("2f8e8e23-ee58-47bb-9610-6881652a1f34")
  """
  @spec get_image_url(String.t) :: {:ok, String.t} | {:error, String.t}
  def get_image_url(id) do
    case find_image(id) do
      nil -> nil
      image -> get_image_url(image)
    end
  end

  @doc """
  Returns image url for provided Rsim.Image ID and specified width and height.

  If resized image does not exist - parent image will be resized and saved to storage and repo,
  resized image url will be returned.

  {:ok, image_url} = Rsim.ImageFetcher.get_image_url("2f8e8e23-ee58-47bb-9610-6881652a1f34", 150, 200)
  """
  @spec get_image_url(String.t, number, number) :: {:ok, String.t} | {:error, String.t}
  def get_image_url(image_id, width, height) do
    case find_image(image_id, width, height) do
      nil ->
        {:ok, image} =
          find_image(image_id)
          |> create_resized_image(width, height)

        get_image_url(image)

      image ->
        get_image_url(image)
    end
  end

  defp find_image(id), do: Rsim.Config.image_repo().find(id)
  defp find_image(id, width, height), do: Rsim.Config.image_repo().find(id, width, height)

  defp create_resized_image(original_image, _width, _height) when is_nil(original_image), do: nil

  defp create_resized_image(original_image = %Image{}, width, height) do
    {:ok, original_image_url} = get_image_url(original_image)
    {:ok, tmp_path} = ImageDownloader.to_tmp_file(original_image_url)
    tmp_dest_path = PathBuilder.tmp_path_from_url(original_image_url)
    Path.dirname(tmp_dest_path) |> File.mkdir_p!()
    :ok = Rsim.Config.resizer().resize(tmp_path, tmp_dest_path, width, height)

    Rsim.StorageUploader.save_resized_image(tmp_dest_path, original_image)
  end
end
