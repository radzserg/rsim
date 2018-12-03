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

  test "it returns saved image" do
    image = %Rsim.Image{id: UUID.uuid4(), type: "user", path: "user/uniq/image.jpg", mime: "image/png", size: 100}
    {:ok, _ecto_image} = ImageEctoRepo.save(image)

    found_image = ImageEctoRepo.find(image.id)
    assert found_image == image
  end

  test "it returns resized image" do
    image_id = UUID.uuid4()
    parent_id = UUID.uuid4()
    ecto_image = %Rsim.EctoImage{id: parent_id, type: "user", path: "user/uniq/image.jpg",
      mime: "image/png", size: 100, width: 300, height: 400}
    resized_ecto_image = %Rsim.EctoImage{id: image_id, parent_id: parent_id, type: "user", path: "user/uniq/image.jpg",
      mime: "image/png", size: 100, width: 100, height: 200}
    Rsim.Config.repo().insert!(ecto_image)
    Rsim.Config.repo().insert!(resized_ecto_image)

    found_image = ImageEctoRepo.find(parent_id, 100, 200)
    assert %Rsim.EctoImage{} = found_image
    assert found_image.id == resized_ecto_image.id
  end
end
