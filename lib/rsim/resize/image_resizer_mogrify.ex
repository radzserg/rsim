defmodule Rsim.ImageResizerMogrify do
  import Mogrify

  @behaviour Rsim.ImageResizer

  @impl Rsim.ImageResizer
  def resize(src, dest, width, height) do
    open(src)
      |> resize_to_fill("#{width}x#{height}")
      |> gravity("center")
      |> save(path: dest)
    :ok
  end
end