defmodule Rsim.Repo.Migrations.AddImages do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string, null: false
      add :path, :string, null: false
      add :mime, :string
      add :size, :integer
      add :width, :integer
      add :height, :integer
      add :parent_id, references(:images, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:images, [:parent_id])
    create index(:images, [:parent_id, :width, :height])
  end
end
