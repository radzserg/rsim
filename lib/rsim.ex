defmodule Rsim do
  @moduledoc """
  Image manager - allows to update upload images to storage. Storage adapters are AWS S3, and.

  """

  @doc """
  Saves image provided via URL, returns Rsim.image
  """
  @spec save_image_from_url(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  defdelegate save_image_from_url(url, image_type), to: Rsim.HasImage

  @doc """
  Saves image from local path, returns Rsim.image
  """
  @spec save_image_from_file(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  defdelegate save_image_from_file(file_path, image_type), to: Rsim.HasImage

end
