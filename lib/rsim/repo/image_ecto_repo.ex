defmodule Rsim.ImageEctoRepo do

  import Ecto.Changeset

  alias Rsim.Image
  alias Rsim.EctoImage

  @doc """
  Save file to storage
  """
  @callback save(Rsim.Image.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def save(image = %Image{}) do
    changeset = add_changeset(image)
    Rsim.Config.repo().insert(changeset)
  end

  @doc """
  Find image in repo by id
  """
  @callback find(String.t()) :: Rsim.Image.t() | nil
  def find(id) do
    case Rsim.Config.repo().get(EctoImage, id) do
      nil -> nil
      ecto_image -> EctoImage.to_image(ecto_image)
    end
  end

  def add_changeset(image = %Image{}) do
    params = Map.from_struct(image)

    %EctoImage{}
    |> cast(params, [:id, :type, :path, :size, :mime])
    |> validate_required([:id, :type, :path, :size, :mime])
  end
end