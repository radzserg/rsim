defmodule Rsim.ImageFetcher do

  alias Rsim.Image

  def get_image(id) do
    case find_image(id) do
      nil -> nil
      image -> Rsim.Config.storage().file_url(image.path)
    end
  end

  def get_image(origina_image_id, width, height) do
    case find_image(origina_image_id, width, height) do
      nil ->
        find_image(origina_image_id)
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
    # todo download, resize, upload
    # image = %Image{id: id, type: Atom.to_string(image_type), path: storage_path, mime: mime, size: size}
    #resized_image = %Image{id: UUID.uuid4(), type: type, mime: mime}
    # IO.inspect width
    # IO.inspect height
  end
end
