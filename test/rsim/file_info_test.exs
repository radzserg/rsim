defmodule RsimTest.FileInfoTest do
  use ExUnit.Case
  doctest Rsim.FileInfo

  alias Rsim.FileInfo

  test "it define png mime type properly" do
    path = System.cwd() <> "/test/files/1x1.png"
    assert "image/png" == FileInfo.get_mime!(path)
  end

  test "it define jpg mime type properly" do
    path = System.cwd() <> "/test/files/1x1.jpg"
    assert "image/jpeg" == FileInfo.get_mime!(path)
  end
end
