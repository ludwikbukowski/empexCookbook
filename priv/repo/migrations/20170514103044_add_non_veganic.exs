defmodule RealWorld.Repo.Migrations.AddIngredientlistToRecipes do
  use Ecto.Migration

  def change do
    create table(:non_veganic) do
      add(:name, :string)
    end
  end
end
