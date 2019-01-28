defmodule RealWorld.Blog.Ingredient do
  @moduledoc """
  The Ingredient Model
  """

  use Ecto.Schema
import Ecto.Changeset

  embedded_schema do
    field :name, :string
  end

    def changeset(schema, params) do
      schema
      |> cast(params, [:name])
    end

end
