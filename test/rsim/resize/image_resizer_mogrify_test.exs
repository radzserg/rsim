defmodule RsimTest.ImageResizerMogrifyTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageResizerMogrify

  alias Rsim.ImageResizerMogrify

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
    {:ok, result_width, result_height} = Rsim.ImageMeterMogrify.size(dest_path)
    assert 5 == result_width
    assert 6 == result_height
  end
end
