defmodule Rsim.ImageMeterMogrify do
  import Mogrify

  @behaviour Rsim.ImageSize

  @impl Rsim.ImageSize
  def size(src) do
    image = open(src) |> verbose
    {:ok, image.width, image.height}
  end
end