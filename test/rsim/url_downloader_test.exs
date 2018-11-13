defmodule RsimTest.UrlDownloaderTest do
  use ExUnit.Case
  doctest Rsim.UrlDownloader

  alias Rsim.FileInfo
  alias Rsim.UrlDownloader

  test "it saves image provided by URL to tmp path" do
    url = "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"
    tmp_path = UrlDownloader.to_tmp_file(url)

    assert File.exists? tmp_path
    assert "image/png" == FileInfo.get_mime!(tmp_path)
    assert 95 == FileInfo.get_size!(tmp_path)
  end
end
