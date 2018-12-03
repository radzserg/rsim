defmodule RsimTest.ImageResizerMogrifyTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageResizerMogrify

  alias Rsim.ImageResizerMogrify

  import Mogrify

  setup_all do
    dest_path = System.cwd() <> "/test/files/5x6.jpg"
    File.rm! dest_path

    :ok
  end

  test "it resizes provided image" do
    file_path = System.cwd() <> "/test/files/10x10.jpg"
    dest_path = System.cwd() <> "/test/files/5x6.jpg"
    width = 5
    height = 6
    ImageResizerMogrify.resize(file_path, dest_path, width, height)

    assert File.exists? dest_path
    image = open(dest_path) |> verbose
    assert width == image.width
    assert height == image.height
  end
end
