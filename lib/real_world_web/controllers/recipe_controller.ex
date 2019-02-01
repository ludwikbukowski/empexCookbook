defmodule RealWorldWeb.RecipeController do
  use RealWorldWeb, :controller
  use RealWorldWeb.GuardedController

  alias RealWorld.{Cookbook, Repo}
  alias RealWorld.Cookbook.{Recipe}

  action_fallback(RealWorldWeb.FallbackController)

  plug(
    Guardian.Plug.EnsureAuthenticated
    when action in [
           :create,
           :update,
           :delete,
           :favorite
         ]
  )

  def index(conn, params, user) do
    recipes =
      Cookbook.list_recipes(params)
      |> Repo.preload([:author])

    render(conn, "index.json", recipes: recipes)
  end

  def create(conn, %{"recipe" => params}, user) do
    with {:ok, %Recipe{} = recipe} <- Cookbook.create_recipe(create_params(params, user)) do
      recipe =
        recipe
        |> Repo.preload([:author])

      conn
      |> put_status(:created)
      |> put_resp_header("location", recipe_path(conn, :show, recipe))
      |> render("show.json", recipe: recipe)
    end
  end

  def show(conn, %{"id" => slug}, user) do
    recipe =
      slug
      |> Cookbook.get_recipe_by_slug!()
      |> Repo.preload([:author])

    render(conn, "show.json", recipe: recipe)
  end

  defp create_params(params, user) do
    unified_list = Enum.map(params["ingredients"], fn %{"name" => val} -> val end)

    params
    |> Map.merge(%{"user_id" => user.id})
  end

  def feed(conn, _params, user) do
    recipes =
      user
      |> Cookbook.feed()

    render(conn, "index.json", recipes: recipes)
  end

  defp get_recipes(), do: []

  def delete(conn, %{"id" => slug}, _user) do
    Cookbook.delete_recipe(slug)
    send_resp(conn, :no_content, "")
  end
end
