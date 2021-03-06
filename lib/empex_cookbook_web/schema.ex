defmodule EmpexCookbookWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  alias EmpexCookbookWeb.Resolvers
  alias EmpexCookbookWeb.Resolvers

  #  import_types EmpexCookbookWeb.Schema.InputObjects
  import_types(EmpexCookbookWeb.Schema.Objects)
  import_types(EmpexCookbookWeb.Schema.Scalars)

  query do
    field :recipe, :recipe do
      arg(:name, :string, description: "The name of the recipe")
      resolve(&Resolvers.RecipeResolver.find_by_name/2)
    end

    field :recipes, list_of(:recipe) do
      arg(:ingredients, list_of(:string),
        description: "The required list of the ingredients of the recipe"
      )

      resolve(&Resolvers.RecipeResolver.find_by_ingredient_list/2)
    end

    field :user, :user do
      arg(:email, non_null(:string))
      resolve(&Resolvers.RecipeResolver.find_user_by_email/2)
    end

    field :all_recipes, list_of(:recipe) do
      resolve(&Resolvers.RecipeResolver.all/2)
    end
  end

  def middleware(middleware, field, object) do
    [EmpexCookbook.TraceMiddleware | middleware]
#    middleware
  end
end
