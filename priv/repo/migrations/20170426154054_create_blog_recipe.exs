defmodule RealWorld.Repo.Migrations.CreateRealWorld.Blog.Recipe do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add(:title, :string)
      add(:body, :text)
      add(:slug, :string)

      timestamps(inserted_at: :created_at)
    end

    create(unique_index(:recipes, [:slug]))
  end
end
