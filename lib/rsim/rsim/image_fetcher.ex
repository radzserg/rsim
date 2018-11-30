defmodule Rsim.ImageFetcher do

  alias Rsim.Image

  def get_image(id, opts \\ [])
  def get_image(id, opts) when is_bitstring(id) do
    case Rsim.Config.image_repo().find(id) do
      nil -> nil
      image -> get_image(image, opts)
    end
  end
  def get_image(image = %Image{}, _opts) do
    Rsim.Config.storage().file_url(image.path)
  end
end
