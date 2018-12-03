defmodule Rsim.ImageFetcher do

  def get_image(id, opts \\ [])
  def get_image(id, opts) when is_bitstring(id) do
    width = Keyword.get(opts, :width)
    height = Keyword.get(opts, :height)
    case Rsim.Config.image_repo().find(id, width, height) do
      nil -> nil
      image -> Rsim.Config.storage().file_url(image.path)
    end
  end
end
