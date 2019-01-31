defmodule RealworldWeb.Resolvers.RecipeResolver do
  alias CookbookAppGql.Accounts

  def all(_args, _info) do
    RealWorld.Metrics.bump_one_lookup("lookups")
    {:ok, RealWorld.Cookbook.list_recipes(%{})}
  end

  def find(%{name: name}, _info) do
    RealWorld.Metrics.bump_one_lookup("lookups")

    case RealWorld.Cookbook.get_recipe_by_name(name) do
      nil -> {:error, "No recipe with name #{name}"}
      recipe -> {:ok, recipe}
    end
  end

  def find(%{ingredients: list}, _info) do
    RealWorld.Metrics.bump_one_lookup("lookups")

    case RealWorld.Cookbook.get_recipe_by_ingredients(list) do
      nil -> {:error, "No recipes with #{list}"}
      recipe -> {:ok, recipe}
    end
  end

  def find_user_by_email(%{email: email}, _info) do
    RealWorld.Metrics.bump_one_lookup("lookups")

    case RealWorld.Cookbook.get_user_by_email(email) do
      nil -> {:error, "No Users with email #{email}"}
      recipe -> {:ok, recipe}
    end
  end
end
