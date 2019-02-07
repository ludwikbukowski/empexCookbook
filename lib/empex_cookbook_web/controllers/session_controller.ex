defmodule EmpexCookbookWeb.SessionController do
  use EmpexCookbookWeb, :controller

  alias EmpexCookbook.Accounts.Auth

  action_fallback(EmpexCookbookWeb.FallbackController)

  def create(conn, params) do
    case Auth.find_user_and_check_password(params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
          user |> EmpexCookbookWeb.Guardian.encode_and_sign(%{}, token_type: :token)

        conn
        |> put_status(:created)
        |> render(EmpexCookbookWeb.UserView, "login.json", jwt: jwt, user: user)

      {:error, message} ->
        conn
        |> put_status(401)
        |> render(EmpexCookbookWeb.UserView, "error.json", message: message)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> render(EmpexCookbookWeb.UserView, "error.json", message: "Not Authenticated")
  end
end
