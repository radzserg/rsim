defmodule RsimTest.ImageEctoRepoTest do
  use Rsim.DataCase, async: true
  doctest Rsim.ImageEctoRepo

  alias Rsim.ImageEctoRepo

  defp build_test_image() do
    %Rsim.Image{
      id: UUID.uuid4(),
      type: "user",
      path: "user/uniq/image.jpg",
      mime: "image/png",
      size: 100,
      width: 100,
      height: 200
    }
  end

  test "it should add new image to repo" do
    image = build_test_image()
    {:ok, ecto_image} = ImageEctoRepo.save(image)
    assert %Rsim.EctoImage{} = ecto_image
    assert ecto_image.id == image.id
    assert ecto_image.type == image.type
    assert ecto_image.path == image.path
    assert ecto_image.mime == image.mime
    assert ecto_image.size == image.size
  end

  test "it saves new image with parent_id" do
    parent_image = build_test_image()
    {:ok, ecto_parent_image} = ImageEctoRepo.save(parent_image)
    image = build_test_image()

    {:ok, ecto_image} = ImageEctoRepo.save(image, ecto_parent_image.id)
    assert %Rsim.EctoImage{} = ecto_image
    assert ecto_parent_image.id == ecto_image.parent_id
  end

  test "it return error if image does not have id" do
    image =
      build_test_image()
      |> Map.put(:id, nil)

    {:error, changeset} = ImageEctoRepo.save(image)
    refute changeset.valid?
  end

  test "it returns saved image" do
    image = build_test_image()
    {:ok, _ecto_image} = ImageEctoRepo.save(image)

    found_image = ImageEctoRepo.find(image.id)
    assert found_image == image
  end

  test "it returns resized image" do
    image_id = UUID.uuid4()
    parent_id = UUID.uuid4()

    ecto_image = %Rsim.EctoImage{
      id: parent_id,
      type: "user",
      path: "user/uniq/image.jpg",
      mime: "image/png",
      size: 100,
      width: 300,
      height: 400
    }

    resized_ecto_image = %Rsim.EctoImage{
      id: image_id,
      parent_id: parent_id,
      type: "user",
      path: "user/uniq/image.jpg",
      mime: "image/png",
      size: 100,
      width: 100,
      height: 200
    }

    Rsim.Config.repo().insert!(ecto_image)
    Rsim.Config.repo().insert!(resized_ecto_image)

    found_image = ImageEctoRepo.find(parent_id, 100, 200)
    assert %Rsim.Image{} = found_image
    assert found_image.id == resized_ecto_image.id
  end

  test "it returns all sizes of image" do
    {:ok, image} =
      Rsim.Config.repo().insert(%Rsim.EctoImage{
        id: UUID.uuid4(),
        type: "user",
        path: "user/uniq/image.jpg",
        mime: "image/png",
        size: 100,
        width: 100,
        height: 200
      })

    {:ok, resized_image} =
      Rsim.Config.repo().insert(%Rsim.EctoImage{
        id: UUID.uuid4(),
        type: "user",
        path: "user/uniq/image.jpg",
        mime: "image/png",
        size: 80,
        width: 50,
        height: 100,
        parent_id: image.id
      })

    images = ImageEctoRepo.find_all_sizes_of_image(image.id)
    image_ids = Enum.map(images, & &1.id)
    assert [image.id, resized_image.id] == image_ids
  end

  test "it deletes images by provided IDs" do
    image_id_1 = "2f8e8e23-ee58-47bb-9610-6881652a1f35"
    image_id_2 = "2f8e8e23-ee58-47bb-9610-6881652a1f36"

    {:ok, _} =
      Rsim.Config.repo().insert(%Rsim.EctoImage{
        id: image_id_1,
        type: "user",
        path: "user/uniq/image.jpg",
        mime: "image/png",
        size: 100,
        width: 100,
        height: 200
      })

    {:ok, _} =
      Rsim.Config.repo().insert(%Rsim.EctoImage{
        id: image_id_2,
        type: "user",
        path: "user/uniq/image.jpg",
        mime: "image/png",
        size: 80,
        width: 50,
        height: 100
      })

    assert :ok == ImageEctoRepo.delete_all([image_id_1, image_id_2])
    refute Rsim.Config.repo().get(Rsim.EctoImage, image_id_1)
    refute Rsim.Config.repo().get(Rsim.EctoImage, image_id_2)
  end
end
