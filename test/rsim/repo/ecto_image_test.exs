defmodule RsimTest.EctoImageTest do
  use ExUnit.Case, async: true
  doctest Rsim.EctoImage

  test "it converts ecto_image to image" do
    ecto_image = %Rsim.EctoImage{id: UUID.uuid4(), type: "user", path: "user/uniq/image.jpg", mime: "image/png", size: 100}
    image = Rsim.EctoImage.to_image(ecto_image)
    assert %Rsim.Image{} = image
    assert image.id == ecto_image.id
    assert image.type == ecto_image.type
    assert image.path == ecto_image.path
    assert image.mime == ecto_image.mime
    assert image.size == ecto_image.size
    assert image.width == ecto_image.width
    assert image.height == ecto_image.height
  end
end
