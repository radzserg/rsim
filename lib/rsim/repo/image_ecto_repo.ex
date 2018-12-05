defmodule Rsim.ImageEctoRepo do

  import Ecto.Changeset

  alias Rsim.Image
  alias Rsim.EctoImage

  @behaviour Rsim.ImageRepo

  import Ecto.Query, only: [from: 2]

  @doc """
  Save file to repo
  """
  @impl Rsim.ImageRepo
  @spec save(Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def save(image = %Image{}) do
    params = Map.from_struct(image)
    changeset = add_changeset(params)
    Rsim.Config.repo().insert(changeset)
  end

  @doc """
  Save file to repo with specified parent image id
  """
  @impl Rsim.ImageRepo
  @spec save(Rsim.Image.t(), String.t) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def save(image = %Image{}, parent_image_id) do
    params = Map.from_struct(image)
      |> Map.put(:parent_id, parent_image_id)
    changeset = add_changeset(params)
    Rsim.Config.repo().insert(changeset)
  end

  @doc """
  Find image in repo by id
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
  """
  @impl Rsim.ImageRepo
  @spec find(String.t(), integer(), integer()) :: Rsim.Image.t() | nil
  def find(image_id, width, height) do
    query = from im in Rsim.EctoImage,
      where: (im.id == ^image_id or im.parent_id == ^image_id) and im.width == ^width and im.height == ^height

    case Rsim.Config.repo().one(query) do
      nil -> nil
      image -> image
    end
  end

  def add_changeset(params) do
    %EctoImage{}
      |> cast(params, [:id, :type, :path, :size, :mime, :width, :height, :parent_id])
      |> validate_required([:id, :type, :path, :size, :mime, :width, :height])
  end
end