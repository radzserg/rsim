defmodule RsimTest.ImageFetcherTest do
  use ExUnit.Case, async: true
  doctest Rsim.ImageFetcher

  alias Rsim.ImageFetcher

  import Mox

  setup :verify_on_exit!

  test "it return valid image src for saved image" do
    image_id = "2f8e8e23-ee58-47bb-9610-6881652a1f34"
    image = %Rsim.Image{
      id: image_id,
      mime: "image/png",
      path: "user/uniq/image.jpg",
      size: 100,
      type: "user"
    }
    image_path = image.path
    expected_url = "https://s3.amazonaws.com/rsim-test/test/files/1x1.jpg"

    Rsim.StorageMock
      |> expect(:file_url, fn ^image_path -> expected_url end)
    Rsim.ImageRepoMock
      |> expect(:find, fn ^image_id -> image end)

    assert expected_url == ImageFetcher.get_image(image_id)
  end
end