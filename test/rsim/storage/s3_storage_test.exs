defmodule RsimTest.S3StorageTest do
  use ExUnit.Case, async: true
  doctest Rsim.S3Storage

  alias Rsim.S3Storage

  test "it saves file to s3" do
    file_path = System.cwd() <> "/test/files/1x1.jpg"
    assert :ok == S3Storage.save_file(file_path, "test/files/1x1.jpg")
  end

  test "it returns valid URL for saved object" do
    key = "test/files/1x1.jpg"
    file_path = System.cwd() <> "/test/files/1x1.jpg"
    assert :ok == S3Storage.save_file(file_path, key)

    assert "https://s3.amazonaws.com/rsim-test/test/files/1x1.jpg" == S3Storage.file_url(key)
  end
end
