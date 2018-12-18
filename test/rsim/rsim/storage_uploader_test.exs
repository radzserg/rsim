defmodule RsimTest.StorageUploaderTest do
  use ExUnit.Case, async: true
  doctest Rsim.StorageUploader

  import Mox

  setup :verify_on_exit!

  alias Rsim.StorageUploader
  alias Rsim.Image

  @valid_image_url "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"
  @invalid_image_url "https://upload.wikimedia.org/1x1.png"

  test "it saves image to DB and return its ID" do
    ecto_image = %Rsim.EctoImage{
      id: "2f8e8e23-ee58-47bb-9610-6881652a1f35",
      mime: "image/png",
      path: "user/uniq/image.jpg",
      size: 100,
      width: 500,
      height: 400,
      type: "users"
    }

    Rsim.StorageMock
    |> expect(:save_file, fn _, _ -> :ok end)

    Rsim.ImageRepoMock
    |> expect(:save, fn %Image{} -> {:ok, ecto_image} end)

    Rsim.ImageMeterMock
    |> expect(:size, fn _ -> {:ok, 500, 100} end)

    {:ok, image} = StorageUploader.save_image_from_url(@valid_image_url, :users)
    assert %Image{} = image
    assert "image/png" == image.mime
    assert 100 == image.size
    assert "users" == image.type
    assert image.id
    assert image.path
    assert 500 == image.width
    assert 400 == image.height
  end

  test "it returns error if file cannot be downloaded" do
    {:error, :not_exists} = StorageUploader.save_image_from_url(@invalid_image_url, :users)
  end

  test "it returns error if file cannot be saved to storage" do
    Rsim.StorageMock
    |> expect(:save_file, fn _, _ -> {:error, :not_exists} end)

    Rsim.ImageMeterMock
    |> expect(:size, fn _ -> {:ok, 200, 300} end)

    {:error, :not_exists} = StorageUploader.save_image_from_url(@valid_image_url, :users)
  end

  test "it returns error if image cannot be saved to repo" do
    url = "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"
    error = %Ecto.Changeset{}

    Rsim.StorageMock
    |> expect(:save_file, fn _, _ -> :ok end)

    Rsim.ImageRepoMock
    |> expect(:save, fn %Image{} -> {:error, error} end)

    Rsim.ImageMeterMock
    |> expect(:size, fn _ -> {:ok, 200, 300} end)

    {:error, _error} = StorageUploader.save_image_from_url(url, :users)
  end

  test "it uploads resized image" do
    original_image = %Rsim.Image{
      id: "2f8e8e23-ee58-47bb-9610-6881652a1f34",
      mime: "image/png",
      path: "user/uniq/image.jpg",
      size: 100,
      width: 500,
      height: 400,
      type: "users"
    }

    resized_image = %Rsim.EctoImage{
      id: "2f8e8e23-ee58-47bb-9610-6881652a1f35",
      parent_id: original_image.id,
      mime: "image/png",
      path: "user/uniq/image.jpg",
      size: 100,
      width: 500,
      height: 400,
      type: "users"
    }

    resized_image_path = System.cwd() <> "/test/files/1x1.png"

    Rsim.StorageMock
    |> expect(:save_file, fn ^resized_image_path, _ -> :ok end)

    Rsim.ImageMeterMock
    |> expect(:size, fn _ -> {:ok, 200, 300} end)

    Rsim.ImageRepoMock
    |> expect(:save, fn %Image{} -> {:ok, resized_image} end)

    assert {:ok, image} = StorageUploader.save_resized_image(resized_image_path, original_image)
    assert %Image{} = image
    assert "image/png" == image.mime
    assert 100 == image.size
    assert "users" == image.type
    assert image.id
    assert image.path
    assert 500 == image.width
    assert 400 == image.height
  end
end
