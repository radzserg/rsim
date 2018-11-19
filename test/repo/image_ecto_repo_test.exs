defmodule RsimTest.ImageEctoRepoTest do
  use Rsim.DataCase, async: true
  doctest Rsim.ImageEctoRepo

  alias Rsim.ImageEctoRepo

  test "it should add new image to repo" do
    image = %Rsim.Image{id: UUID.uuid4(), type: "user", path: "user/uniq/image.jpg", mime: "image/png", size: 100}
    {:ok, ecto_image} = ImageEctoRepo.save(image)
    assert %Rsim.EctoImage{} = ecto_image
    assert ecto_image.id == image.id
    assert ecto_image.type == image.type
    assert ecto_image.path == image.path
    assert ecto_image.mime == image.mime
    assert ecto_image.size == image.size
  end

  test "it return error if image does not have id" do
    image = %Rsim.Image{id: nil, type: "user", path: "user/uniq/image.jpg", mime: "image/png", size: 100}
    {:error, changeset} = ImageEctoRepo.save(image)
    refute changeset.valid?
  end
end
