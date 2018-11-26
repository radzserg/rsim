defmodule Rsim.ImageEctoRepo do

  import Ecto.Changeset

  alias Rsim.Image
  alias Rsim.EctoImage

  def save(image = %Image{}) do
    changeset = add_changeset(image)
    Rsim.Config.repo().insert(changeset)
  end

  def add_changeset(image = %Image{}) do
    params = Map.from_struct(image)

    %EctoImage{}
    |> cast(params, [:id, :type, :path, :size, :mime])
    |> validate_required([:id, :type, :path, :size, :mime])
  end
end