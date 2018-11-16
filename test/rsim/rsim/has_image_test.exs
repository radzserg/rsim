defmodule RsimTest.HasImageTest do
  use ExUnit.Case, async: true
  doctest Rsim.HasImage

  import Mox

  setup :verify_on_exit!

  alias Rsim.HasImage
  alias Rsim.Image

  test "it saves image to DB and return it's ID" do
    url = "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png"

    Rsim.StorageMock
      |> expect(:save_file, fn _, _, _ -> :ok end)
    Rsim.ImageRepoMock
      |> expect(:save, fn %Image{} -> {:ok, %{}} end)

    {:ok, image} = HasImage.save_image_from_url(url, "users")
    assert %Image{} = image
    assert "image/png" == image.mime
    assert 95 == image.size
    assert "users" == image.type
    assert image.id
    assert image.path
  end
end
