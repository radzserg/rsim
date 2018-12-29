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
    image = open(path) |> verbose
    {:ok, image.width, image.height}
  end
end
