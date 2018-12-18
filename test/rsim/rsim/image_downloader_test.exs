defmodule RsimTest.ImageDownloaderTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageDownloader

  alias Rsim.FileInfo
  alias Rsim.ImageDownloader

  test "it saves image provided by URL to tmp path" do
    url = "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"
    {:ok, tmp_path} = ImageDownloader.to_tmp_file(url)

    assert File.exists?(tmp_path)
    assert "image/png" == FileInfo.get_mime!(tmp_path)
    assert 95 == FileInfo.get_size!(tmp_path)
  end

  test "it returns :not_exists if image path is invalid" do
    url = "https://upload.wikimedia.org/1x1.png"
    {:error, :not_exists} = ImageDownloader.to_tmp_file(url)
  end

  test "it raise HTTPoison error when HTTPoison cannot perform request" do
    url = "https://example/1x1.png"
    assert {:error, :nxdomain} = ImageDownloader.to_tmp_file(url)
  end
end
