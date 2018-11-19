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

end
