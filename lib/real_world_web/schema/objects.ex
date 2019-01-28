defmodule RealWorldWeb.Schema.Objects do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :recipe do
    field(:id, :id)
    field(:title, :string)
    field(:body, :string)
  end
end
