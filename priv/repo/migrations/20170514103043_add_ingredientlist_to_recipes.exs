defmodule RealWorld.Repo.Migrations.AddIngredientlistToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      #      add(:ingredients, {:array, :string})
      add(:ingredients, {:array, :map}, default: [])
    end

    execute("CREATE INDEX recipe_ingredients_index ON recipes USING GIN(ingredients)")
  end
end
