defmodule RsimTest.MeterMogrifyTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageMeterMogrify

  alias Rsim.ImageMeterMogrify

  test "it defines the size of the image" do
    file_path = System.cwd() <> "/test/files/10x10.jpg"

    {:ok, width, height} = ImageMeterMogrify.size(file_path)
    assert 10 == width
    assert 10 == height
  end
end
