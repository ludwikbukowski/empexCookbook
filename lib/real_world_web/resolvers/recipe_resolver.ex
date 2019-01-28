defmodule RealworldWeb.Resolvers.RecipeResolver do
  alias BlogAppGql.Accounts

  def all(_args, _info) do
    {:ok, RealWorld.Blog.list_recipes(%{})}
  end

  def find(%{ingredient: ingredient}, _info) do
    case RealWorld.Blog.get_recipe_by_ingredient(ingredient) do
      nil -> {:error, "No recipes with #{ingredient}"}
      recipe -> {:ok, recipe}
    end
  end
end
