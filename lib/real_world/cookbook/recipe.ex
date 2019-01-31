defmodule RealWorld.Cookbook.Recipe do
  @moduledoc """
  The Recipe Model
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias RealWorld.Accounts.User
  alias RealWorld.Cookbook.{Recipe, Ingredient}

  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(title body user_id)a
  @optional_fields ~w(slug picture)a

  schema "recipes" do
    field(:body, :string)
    field(:title, :string)
    field(:picture, :string)
    field(:slug, :string)

    embeds_many(:ingredients, Ingredient)

    belongs_to(:author, User, foreign_key: :user_id)

    timestamps(inserted_at: :created_at)
  end

  def changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:ingredients)
    |> validate_required(@required_fields)
    |> assoc_constraint(:author)
    |> unique_constraint(:slug, name: :recipes_slug_index)
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
