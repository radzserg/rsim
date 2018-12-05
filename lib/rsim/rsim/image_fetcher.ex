defmodule Rsim.ImageFetcher do

  alias Rsim.Image
  alias Rsim.ImageDownloader
  alias Rsim.PathBuilder

  def get_image(image= %Image{}) do
    Rsim.Config.storage().file_url(image.path)
  end
  def get_image(id) do
    case find_image(id) do
      nil -> nil
      image -> get_image(image)
    end
  end
  def get_image(image_id, width, height) do
    case find_image(image_id, width, height) do
      nil ->
        find_image(image_id)
          |> create_resized_image(width, height)
      image -> image_url(image)
    end
  end

  defp find_image(id), do: Rsim.Config.image_repo().find(id)
  defp find_image(id, width, height), do: Rsim.Config.image_repo().find(id, width, height)

  defp image_url(image = %Image{}) do
    Rsim.Config.storage().file_url(image.path)
  end

  defp create_resized_image(original_image, _width, _height) when is_nil(original_image), do: nil
  defp create_resized_image(original_image = %Image{}, width, height) do
    original_image_url = get_image(original_image)
    {:ok, tmp_path} = ImageDownloader.to_tmp_file(original_image_url)
    tmp_dest_path = PathBuilder.tmp_path_from_url(original_image_url)
    Rsim.Config.resizer().resize(tmp_path, tmp_dest_path, width, height)

    Rsim.StorageUploader.save_resized_image(tmp_dest_path, original_image)
  end
end
