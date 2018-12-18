defmodule Rsim.ImageResizerMogrify do
  import Mogrify

  @behaviour Rsim.ImageResizer

  @impl Rsim.ImageResizer
  @doc """
  Resize provided image to specified size, saves to dest path

  :ok = Rsim.ImageResizerMogrify.resize("/path/to/src.png", "/path/to/dest.png", 200, 100)
  """
  @spec resize(String.t(), String.t(), number, number) :: :ok | {:error, String.t()}
  def resize(src, dest, width, height) do
    open(src)
    |> resize_to_fill("#{width}x#{height}")
    |> gravity("center")
    |> save(path: dest)

    :ok
  end
end
