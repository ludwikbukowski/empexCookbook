defmodule EmpexCookbookWeb.RecipeControllerTest do
  use EmpexCookbookWeb.ConnCase

  import EmpexCookbook.Factory

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{
    body: "some updated body",
    title: "some updated title"
  }
  @invalid_attrs %{body: nil, title: nil}

  setup do
    user = insert(:user)
    recipe = insert(:recipe, author: user)
    {:ok, jwt, _full_claims} = EmpexCookbookWeb.Guardian.encode_and_sign(user)
    {:ok, %{recipe: recipe, user: user, jwt: jwt}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, recipe_path(conn, :index))
    assert json_response(conn, 200)["recipes"] != []
  end

  test "creates recipe and renders recipe when data is valid", %{conn: conn, jwt: jwt} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = post(conn, recipe_path(conn, :create), recipe: @create_attrs)
    json = json_response(conn, 201)["recipe"]

    assert json == %{
             "id" => json["id"],
             "body" => "some body",
             "slug" => "some-title",
             "createdAt" => json["createdAt"],
             "updatedAt" => json["updatedAt"],
             "title" => "some title",
             "author" => %{"bio" => "some bio", "image" => "some image", "username" => "john"},
             "ingredientList" => nil
           }
  end

  test "does not create recipe and renders errors when data is invalid", %{conn: conn, jwt: jwt} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = post(conn, recipe_path(conn, :create), recipe: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen recipe and renders recipe when data is valid", %{
    conn: conn,
    jwt: jwt,
    recipe: recipe
  } do
    recipe_id = recipe.id
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = put(conn, recipe_path(conn, :update, recipe), recipe: @update_attrs)
    assert %{"id" => ^recipe_id} = json_response(conn, 200)["recipe"]

    conn = get(conn, recipe_path(conn, :show, "some-updated-title"))
    json = json_response(conn, 200)["recipe"]

    assert json == %{
             "id" => recipe_id,
             "body" => "some updated body",
             "slug" => "some-updated-title",
             "createdAt" => json["createdAt"],
             "updatedAt" => json["updatedAt"],
             "title" => "some updated title",
             "author" => %{"bio" => "some bio", "image" => "some image", "username" => "john"},
             "ingredientList" => ["tag1", "tag2"]
           }
  end

  test "does not update chosen recipe and renders errors when data is invalid", %{
    conn: conn,
    jwt: jwt,
    recipe: recipe
  } do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = put(conn, recipe_path(conn, :update, recipe), recipe: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen recipe", %{conn: conn, jwt: jwt, recipe: recipe} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = delete(conn, recipe_path(conn, :delete, recipe))
    assert response(conn, 204)

    assert_error_sent(404, fn ->
      get(conn, recipe_path(conn, :show, recipe))
    end)
  end
end
