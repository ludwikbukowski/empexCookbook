defmodule EmpexCookbookWeb.CommentController do
  use EmpexCookbookWeb, :controller
  use EmpexCookbookWeb.GuardedController

  alias EmpexCookbook.Cookbook
  alias EmpexCookbook.Cookbook.Comment

  action_fallback(EmpexCookbookWeb.FallbackController)

  plug(Guardian.Plug.EnsureAuthenticated when action in [:create, :update, :delete])

  def index(conn, %{"article_id" => slug}, _user) do
    recipe = Cookbook.get_recipe_by_slug!(slug)
    comments = Cookbook.list_comments(recipe)

    comments =
      comments
      |> EmpexCookbook.Repo.preload(:author)

    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"article_id" => slug, "comment" => comment_params}, user) do
    article = Cookbook.get_recipe_by_slug!(slug)

    with {:ok, %Comment{} = comment} <-
           Cookbook.create_comment(
             comment_params
             |> Map.merge(%{"user_id" => user.id})
             |> Map.merge(%{"article_id" => article.id})
           ) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_params}, _user) do
    comment = Cookbook.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Cookbook.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    comment = Cookbook.get_comment!(id)

    with {:ok, %Comment{}} <- Cookbook.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
