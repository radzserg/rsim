defmodule Rsim.ImageMeterMogrify do
  import Mogrify

  @behaviour Rsim.ImageMeter

  @impl Rsim.ImageMeter
  def size(src) do
    image = open(src) |> verbose
    {:ok, image.width, image.height}
  end
end