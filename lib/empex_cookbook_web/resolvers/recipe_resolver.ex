defmodule EmpexCookbookWeb.Resolvers.RecipeResolver do
  alias CookbookAppGql.Accounts
  use Statix

  def all(_args, _info) do
    EmpexCookbook.Metrics.bump_one_lookup()
    {:ok, EmpexCookbook.Cookbook.list_recipes(%{})}
  end

  def find_by_name(%{name: name}, _info) do
    EmpexCookbook.Metrics.bump_one_lookup()

    case EmpexCookbook.Cookbook.get_recipe_by_name(name) do
      nil -> {:error, "No recipe with name #{name}"}
      recipe -> {:ok, recipe}
    end
  end

  def find_by_ingredient_list(%{ingredients: list}, _info) do
    EmpexCookbook.Metrics.bump_one_lookup()

    case EmpexCookbook.Cookbook.get_recipe_by_ingredients(list) do
      nil -> {:error, "No recipes with #{list}"}
      recipe -> {:ok, recipe}
    end
  end

  def find_user_by_email(%{email: email}, _info) do
    EmpexCookbook.Metrics.bump_one_lookup()

    case EmpexCookbook.Cookbook.get_user_by_email(email) do
      nil -> {:error, "No Users with email #{email}"}
      recipe -> {:ok, recipe}
    end
  end
end
