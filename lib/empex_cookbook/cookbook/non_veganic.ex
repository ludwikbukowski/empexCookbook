defmodule EmpexCookbook.Cookbook.NonVeganic do
  @moduledoc """
  The Ingredient Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "non_veganic" do
    field(:name, :string)
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:name])
  end
end
