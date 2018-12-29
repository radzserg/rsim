defmodule Rsim.ImageResizerMogrify do
  import Mogrify

  @behaviour Rsim.ImageResizer

  @impl Rsim.ImageResizer
  @doc """
  Resize provided image to specified size, saves to dest path

  :ok = Rsim.ImageResizerMogrify.resize("/path/to/src.png", "/path/to/dest.png", 200, 100)
  """
  @spec resize(src_path :: String.t(), dest_path :: String.t(), width :: number, height :: number) ::
          :ok | {:error, String.t()}
  def resize(src_path, dest_path, width, height) do
    open(src_path)
    |> resize_to_fill("#{width}x#{height}")
    |> gravity("center")
    |> save(path: dest_path)

    :ok
  end
end
