defmodule Rsim.ImageMeterMogrify do
  import Mogrify

  @behaviour Rsim.ImageMeter

  @impl Rsim.ImageMeter
  @doc """
  Defines image size by provided file path

      {:ok, width, height} = Rsim.ImageMeterMogrify.size("/path/to/image.jpg")

  """
  @spec size(path :: String.t()) :: {:ok, number, number} | {:error, String.t()}
  def size(path) do
    image = open(path)
    try do
      image_info = verbose(image)
      {:ok, image_info.width, image_info.height}
    rescue
      # prevent error in mogrify
      # ** (MatchError) no match of right hand side value: {"mogrify: insufficient image data in file
      MatchError -> {:ok, 0, 0}
      _ -> {:error, "cannot meter the image"}
    end
  end
end
