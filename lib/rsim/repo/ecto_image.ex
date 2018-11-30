defmodule Rsim.EctoImage do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "images" do
    field :type, :string
    field :path, :string
    field :mime, :string
    field :size, :integer
    field :width, :integer
    field :height, :integer
    belongs_to :parent, Rsim.EctoImage, type: :binary_id

    timestamps()
  end

  @doc """
  Convert EctoImage to raw Image
  """
  def to_image(ecto_image = %Rsim.EctoImage{}) do
    %Rsim.Image{id: ecto_image.id, type: ecto_image.type, path: ecto_image.path,
      mime: ecto_image.mime, size: ecto_image.size
    }
  end

end
