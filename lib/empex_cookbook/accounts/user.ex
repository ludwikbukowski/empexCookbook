defmodule EmpexCookbook.Accounts.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(email username password)a
  @optional_fields ~w(bio image)a

  schema "users" do
    field(:email, :string, unique: true)
    field(:password, :string)
    field(:username, :string, unique: true)
    field(:bio, :string)
    field(:image, :string)

    has_many(:recipes, EmpexCookbook.Cookbook.Recipe)
    has_many(:comments, EmpexCookbook.Cookbook.Comment)

    timestamps(inserted_at: :created_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username, name: :users_username_index)
    |> unique_constraint(:email)
  end
end
