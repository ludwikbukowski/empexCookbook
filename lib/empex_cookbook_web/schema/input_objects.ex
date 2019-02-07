defmodule EmpexCookbookWeb.Schema.InputObjects do
  @moduledoc false

  use Absinthe.Schema.Notation

  input_object :input_volume do
    @desc "Total amount of measurement"
    field(:quantity, :integer)
    @desc "Unit of measurement (\"IG\" or \"L\")"
    field(:uom, :uom)
  end
end
