defmodule EmpexCookbook.Repo.Migrations.CreateEmpexCookbook.Cookbook.Recipe do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add(:title, :string)
      add(:body, :text)
      add(:picture, :string)
      add(:slug, :string)

      timestamps(inserted_at: :created_at)
    end

    create(unique_index(:recipes, [:slug]))
  end
end
