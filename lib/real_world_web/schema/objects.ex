defmodule RealWorldWeb.Schema.Objects do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: RealWorld.Repo
  alias RealWorld.Cookbook
  alias RealWorld.Requester

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:email, :string)

    field :image, :string do
      resolve(fn user, _, _ ->
        Requester.request_image(user.username)
      end)
    end
  end

  object :recipe do
    field(:id, :id)
    field(:title, :string)
    field(:body, :string)

    field :user, :user do
      resolve(fn recipe, _, _ ->
        {:ok, Cookbook.get_user_by_id(recipe.user_id)}
      end)
    end

    field :ingredients, list_of(:string) do
      resolve(fn recipe, _, _ ->
        {:ok, bin_ingredients_names(recipe)}
      end)
    end

    field :veganic, non_null(:boolean) do
      resolve(fn recipe, _, _ ->
        {:ok, veganic?(recipe)}
      end)
    end
  end

  defp veganic?(recipe) do
    bin_names = bin_ingredients_names(recipe)

    non_veganics =
      Cookbook.get_non_veganics()
      |> Enum.map(fn i -> i.name end)

    not Enum.any?(bin_names, fn ingredient -> Enum.member?(non_veganics, ingredient) end)
  end

  defp bin_ingredients_names(recipe) do
    recipe.ingredients
    |> Enum.map(fn i -> i.name end)
  end
end
