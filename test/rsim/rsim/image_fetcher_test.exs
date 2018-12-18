defmodule RsimTest.ImageFetcherTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageFetcher

  alias Rsim.ImageFetcher
  alias Rsim.Image

  import Mox

  setup :verify_on_exit!

  defp create_test_image() do
    %Image{
      id: "2f8e8e23-ee58-47bb-9610-6881652a1f34",
      mime: "image/png",
      path: "user/uniq/image.jpg",
      size: 100,
      width: 500,
      height: 400,
      type: "user"
    }
  end

  test "it return valid image src for saved image" do
    image = create_test_image()
    image_id = image.id
    image_path = image.path
    expected_url = "https://s3.amazonaws.com/rsim-test/test/files/1x1.jpg"

    Rsim.StorageMock
    |> expect(:file_url, fn ^image_path -> {:ok, expected_url} end)

    Rsim.ImageRepoMock
    |> expect(:find, fn ^image_id -> image end)

    assert {:ok, expected_url} == ImageFetcher.get_image_url(image_id)
  end

  test "it should return resized image" do
    image = create_test_image()
    image_id = image.id
    image_path = image.path
    expected_url = "https://s3.amazonaws.com/rsim-test/test/files/1x1.jpg"
    width = 100
    height = 50

    Rsim.StorageMock
    |> expect(:file_url, fn ^image_path -> expected_url end)

    Rsim.ImageRepoMock
    |> expect(:find, fn ^image_id, ^width, ^height -> image end)

    assert expected_url == ImageFetcher.get_image_url(image_id, width, height)
  end

  test "it should create resized image if its missing in storage" do
    original_image = create_test_image()

    resized_ecto_image = %Rsim.EctoImage{
      id: "2f8e8e23-ee58-47bb-9610-6881652a1f35",
      mime: "image/png",
      path: "user/uniq/image.jpg",
      size: 100,
      width: 500,
      height: 400,
      type: "user"
    }

    image_id = original_image.id
    image_path = original_image.path
    expected_url = "https://s3.amazonaws.com/rsim-test/test/files/1x1.jpg"
    width = 100
    height = 50

    Rsim.ImageRepoMock
    |> expect(:find, fn ^image_id, ^width, ^height -> nil end)
    |> expect(:find, fn ^image_id -> original_image end)
    |> expect(:save, fn _ -> {:ok, resized_ecto_image} end)

    Rsim.StorageMock
    |> expect(:file_url, fn ^image_path -> {:ok, "http://original-image.com/url"} end)
    |> expect(:file_url, fn _ -> {:ok, expected_url} end)
    |> expect(:save_file, fn _, _ -> :ok end)

    Rsim.ImageResizerMock
    |> expect(:resize, fn source, dest, ^width, ^height ->
      dest
      |> Path.dirname()
      |> File.mkdir_p!()

      File.copy!(source, dest)
      :ok
    end)

    Rsim.ImageMeterMock
    |> expect(:size, fn _ -> {:ok, width, height} end)

    assert {:ok, expected_url} == ImageFetcher.get_image_url(image_id, width, height)
  end
end
