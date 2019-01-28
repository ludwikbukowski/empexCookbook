defmodule RealWorldWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  alias RealWorldWeb.Resolvers
  alias RealworldWeb.Resolvers

  #  import_types RealWorldWeb.Schema.InputObjects
  import_types(RealWorldWeb.Schema.Objects)
  import_types(RealWorldWeb.Schema.Scalars)

  query do
    field :recipes, list_of(:recipe) do
      resolve(&Resolvers.RecipeResolver.all/2)
    end

    field :recipe, list_of(:recipe) do
      arg(:ingredient, non_null(:string))
      resolve(&Resolvers.RecipeResolver.find/2)
    end
  end
end
