defmodule RsimTest.HasImageTest do
  use ExUnit.Case, async: true
  doctest Rsim.HasImage

  import Mox

  setup :verify_on_exit!

  alias Rsim.HasImage
  alias Rsim.Image

  @valid_image_url "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"
  @invalid_image_url "https://upload.wikimedia.org/1x1.png"

  test "it saves image to DB and return its ID" do

    Rsim.StorageMock
      |> expect(:save_file, fn _, _, _ -> :ok end)
    Rsim.ImageRepoMock
      |> expect(:save, fn %Image{} -> {:ok, %{}} end)

    {:ok, image} = HasImage.save_image_from_url(@valid_image_url, :users)
    assert %Image{} = image
    assert "image/png" == image.mime
    assert 95 == image.size
    assert "users" == image.type
    assert image.id
    assert image.path
  end

  test "it returns error if file cannot be downloaded" do
    {:error, :not_exists} = HasImage.save_image_from_url(@invalid_image_url, :users)
  end

  test "it returns error if file cannot be saved to storage" do
    Rsim.StorageMock
    |> expect(:save_file, fn _, _, _ -> {:error, :not_exists} end)

    {:error, :not_exists} = HasImage.save_image_from_url(@valid_image_url, :users)
  end

  test "it returns error if image cannot be saved to repo" do
    url = "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"
    error = %Ecto.Changeset{}

    Rsim.StorageMock
      |> expect(:save_file, fn _, _, _ -> :ok end)
    Rsim.ImageRepoMock
      |> expect(:save, fn %Image{} -> {:error, error} end)

    {:error, _error} = HasImage.save_image_from_url(url, :users)
  end
end
