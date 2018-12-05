defmodule RsimTest.ImageResizerMogrifyTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageSizeMogrify

  alias Rsim.ImageSizeMogrify

  test "it defines the size of the image" do
    file_path = System.cwd() <> "/test/files/10x10.jpg"

    {:ok, width, height} = ImageSizeMogrify.size(file_path)
    assert 10 == width
    assert 10 == height
  end
end
