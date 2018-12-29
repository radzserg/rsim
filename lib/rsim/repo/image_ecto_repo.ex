defmodule Rsim.ImageEctoRepo do
  import Ecto.Changeset

  alias Rsim.Image
  alias Rsim.EctoImage

  @behaviour Rsim.ImageRepo

  import Ecto.Query, only: [from: 2]

  @doc """
  Save Rsim.Image to repo, returns Rsim.EctoImage

  {:ok, rsim_ecto_image} = Rsim.ImageEctoRepo.save(rsim_image)
  """
  @impl Rsim.ImageRepo
  @spec save(Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def save(image = %Image{}) do
    params = Map.from_struct(image)
    changeset = add_changeset(params)
    Rsim.Config.repo().insert(changeset)
  end

  @doc """
  Save Rsim.Image to repo with provided parent_id, returns Rsim.EctoImage

  {:ok, rsim_ecto_image} = Rsim.ImageEctoRepo.save(rsim_image)
  """
  @impl Rsim.ImageRepo
  @spec save(Rsim.Image.t(), String.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def save(image = %Image{}, parent_image_id) do
    params =
      Map.from_struct(image)
      |> Map.put(:parent_id, parent_image_id)

    changeset = add_changeset(params)
    Rsim.Config.repo().insert(changeset)
  end

  @doc """
  Find image in repo by id, return Rsim.Image

  rsim_image = Rsim.ImageEctoRepo.find(image_id)
  """
  @impl Rsim.ImageRepo
  @spec find(String.t()) :: Rsim.Image.t() | nil
  def find(image_id) do
    case Rsim.Config.repo().get(EctoImage, image_id) do
      nil -> nil
      ecto_image -> EctoImage.to_image(ecto_image)
    end
  end

  @doc """
  Find image in repo by id

  rsim_image = Rsim.ImageEctoRepo.find(image_id, 200, 150)
  """
  @impl Rsim.ImageRepo
  @spec find(String.t(), integer(), integer()) :: Rsim.Image.t() | nil
  def find(image_id, width, height) do
    query =
      from(im in Rsim.EctoImage,
        where:
          (im.id == ^image_id or im.parent_id == ^image_id) and im.width == ^width and
            im.height == ^height
      )

    case Rsim.Config.repo().one(query) do
      nil -> nil
      ecto_image -> EctoImage.to_image(ecto_image)
    end
  end

  @doc """
  Return original image and all resized copies
  """
  @impl Rsim.ImageRepo
  @spec find_all_sizes_of_image(integer()) :: [Rsim.Image.t()]
  def find_all_sizes_of_image(image_id) do
    query = from im in Rsim.EctoImage,
        where: im.id == ^image_id or im.parent_id == ^image_id

    case Rsim.Config.repo().all(query) do
      nil -> nil
      ecto_images -> Enum.map(ecto_images, &EctoImage.to_image/1)
    end
  end

  @doc """
  Deletes all images by provided IDs
  """
  @impl Rsim.ImageRepo
  @spec delete_all(image_ids :: [String.t]) :: :ok | {:error, String.t}
  def delete_all(image_ids) do
    query = from im in Rsim.EctoImage, where: im.id in ^image_ids

    Rsim.Config.repo().delete_all(query)
    :ok
  end

  defp add_changeset(params) do
    %EctoImage{}
    |> cast(params, [:id, :type, :path, :size, :mime, :width, :height, :parent_id])
    |> validate_required([:id, :type, :path, :size, :mime, :width, :height])
  end
end
