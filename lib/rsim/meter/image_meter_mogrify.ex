defmodule Rsim.ImageMeterMogrify do
  import Mogrify

  @behaviour Rsim.ImageMeter

  @impl Rsim.ImageMeter
  @doc """
  Defines image size by provided file path
  {:ok, width, height} = Rsim.ImageMeterMogrify.size("/path/to/image.jpg")
  """
  def size(src) do
    image = open(src) |> verbose
    {:ok, image.width, image.height}
  end
end
