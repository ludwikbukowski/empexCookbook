defmodule RealWorld.Cookbook do
  @moduledoc """
  The boundary for the Cookbook system.
  """

  import Ecto.Query, warn: false
  alias RealWorld.Repo
  use RealWorld.Decorator
  alias RealWorld.Accounts.{User, UserFollower}
  alias RealWorld.Cookbook.{Recipe, NonVeganic, Comment, Favorite}

  @default_pagination_limit 100

  def get_user_by_email(email) do
    from(u in User,
      where: ^email == u.email
    )
    |> Repo.one()
  end

  def get_user_by_id(id) do
    from(u in User,
      where: ^id == u.id
    )
    |> Repo.one()
  end

  def get_non_veganics() do
    from(nv in NonVeganic)
    |> Repo.all()
  end

  def get_non_veganics_with_cache() do
    case Cachex.get(:my_cache, "non_veganics") do
      {:ok, nil} ->
        values = Repo.all(from(nv in NonVeganic))
        Cachex.put(:my_cache, "non_veganics", values)
        values

      {:ok, res} ->
        res
    end
  end

  def list_recipes(params) do
    limit = @default_pagination_limit
    offset = params["offset"] || 0

    from(a in Recipe, limit: ^limit, offset: ^offset, order_by: a.created_at)
    |> Repo.all()
  end

  def get_recipe_by_name(name) do
    from(r in Recipe,
      where: ^name == r.title
    )
    |> Repo.one()
  end

  def get_recipe_by_ingredients(list) do
    Enum.reduce(list, Recipe, fn ingredient, acc ->
      from(r in acc,
        where: fragment("? <@ ANY(?)", ~s|{"name": "#{ingredient}"}|, r.ingredients)
      )
    end)
    |> Repo.all()
  end

  def filter_by_tags(query, nil) do
    query
  end

  def filter_by_tags(query, tag) do
    query
    |> where(
      [a],
      fragment("exists (select * from unnest(?) tag where tag = ?)", a.tag_list, ^tag)
    )
  end

  def feed(user) do
    query =
      from(
        a in Recipe,
        join: uf in UserFollower,
        on: a.user_id == uf.followee_id,
        where: uf.user_id == ^user.id
      )

    query
    |> Repo.all()
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Article{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def get_recipe_by_slug!(slug), do: Repo.get_by!(Recipe, slug: slug)

  @doc """
  Deletes a Recipe.

  ## Examples

      iex> delete_recipe(article)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(slug) do
    case Recipe |> Repo.get_by(slug: slug) do
      nil ->
        false

      recipe ->
        Repo.delete(recipe)
    end
  end

  def list_comments(article) do
    Repo.all(from(c in Comment, where: c.article_id == ^article.id))
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
