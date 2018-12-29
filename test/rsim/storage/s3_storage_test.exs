defmodule RsimTest.S3StorageTest do
  use ExUnit.Case, async: true
  doctest Rsim.S3Storage

  alias Rsim.S3Storage

  test "it saves file to s3" do
    file_path = System.cwd() <> "/test/files/1x1.jpg"
    assert :ok == S3Storage.save(file_path, "test/files/1x1.jpg")
  end

  test "it returns valid URL for saved object" do
    key = "test/files/1x1.jpg"
    file_path = System.cwd() <> "/test/files/1x1.jpg"
    assert :ok == S3Storage.save(file_path, key)

    assert {:ok, "https://s3.amazonaws.com/rsim-test/test/files/1x1.jpg"} ==
             S3Storage.file_url(key)
  end

  test "it deletes files from bucket" do
    key = "test/files/1x1.jpg"
    file_path = System.cwd() <> "/test/files/1x1.jpg"
    assert :ok == S3Storage.save(file_path, key)

    key2 = "test/files/1x1.png"
    file_path2 = System.cwd() <> "/test/files/1x1.png"
    assert :ok == S3Storage.save(file_path2, key2)

    assert :ok == S3Storage.delete_all([key, key2])
  end
end
