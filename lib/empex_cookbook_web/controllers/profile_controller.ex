defmodule EmpexCookbookWeb.ProfileController do
  use EmpexCookbookWeb, :controller
  use EmpexCookbookWeb.GuardedController

  alias EmpexCookbook.Accounts.{Users, User}

  action_fallback(EmpexCookbookWeb.FallbackController)

  plug(Guardian.Plug.EnsureAuthenticated when action in [:follow, :unfollow])

  def show(conn, %{"username" => username}, current_user) do
    case Users.get_by_username(username) do
      user = %User{} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user, following: Users.is_following?(current_user, user))

      nil ->
        conn
        |> put_status(:not_found)
        |> render(EmpexCookbookWeb.ErrorView, "404.json")
    end
  end

  def follow(conn, %{"username" => username}, current_user) do
    case Users.get_by_username(username) do
      followee = %User{} ->
        current_user
        |> Users.follow(followee)

        conn
        |> put_status(:ok)
        |> render(
          "show.json",
          user: followee,
          following: Users.is_following?(current_user, followee)
        )

      nil ->
        conn
        |> put_status(:not_found)
        |> render(EmpexCookbookWeb.ErrorView, "404.json")
    end
  end

  def unfollow(conn, %{"username" => username}, current_user) do
    case Users.get_by_username(username) do
      followee = %User{} ->
        current_user
        |> Users.unfollow(followee)

        conn
        |> put_status(:ok)
        |> render(
          "show.json",
          user: followee,
          following: Users.is_following?(current_user, followee)
        )

      nil ->
        conn
        |> put_status(:not_found)
        |> render(EmpexCookbookWeb.ErrorView, "404.json")
    end
  end
end
