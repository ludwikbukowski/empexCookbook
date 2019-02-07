defmodule EmpexCookbookWeb.RecipeView do
  use EmpexCookbookWeb, :view
  alias EmpexCookbookWeb.{UserView, RecipeView, FormatHelpers}

  def render("index.json", %{recipes: recipes}) do
    %{
      recipes: render_many(recipes, RecipeView, "recipe.json"),
      recipesCount: length(recipes)
    }
  end

  def render("show.json", %{recipe: recipe}) do
    %{recipe: render_one(recipe, RecipeView, "recipe.json")}
  end

  def render("recipe.json", %{recipe: recipe}) do
    ingredients =
      recipe
      |> Map.fetch!(:ingredients)
      |> Enum.map(fn %{name: n} -> n end)

    recipe
    |> Map.from_struct()
    |> Map.put(:created_at, datetime_to_iso8601(recipe.created_at))
    |> Map.put(:updated_at, datetime_to_iso8601(recipe.updated_at))
    |> Map.take([
      :id,
      :body,
      :title,
      :picture,
      :slug,
      :author,
      :created_at,
      :updated_at
    ])
    |> Map.put(:ingredients, ingredients)
    |> Map.put(:author, UserView.render("author.json", user: recipe.author))
    |> FormatHelpers.camelize()
  end

  defp datetime_to_iso8601(datetime) do
    datetime
    |> Map.put(:microsecond, {elem(datetime.microsecond, 0), 3})
    |> DateTime.to_iso8601()
  end
end
