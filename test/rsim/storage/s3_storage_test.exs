defmodule RsimTest.S3StorageTest do
  use ExUnit.Case
  doctest Rsim.S3Storage

  alias Rsim.S3Storage

  test "it saves file to s3" do
    file_path = System.cwd() <> "/test/files/1x1.jpg"
    assert :ok == S3Storage.save_file(file_path, "test/files/1x1.jpg")
  end
end
