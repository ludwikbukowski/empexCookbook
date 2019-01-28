defmodule RealWorldWeb.Schema.Scalars do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc """
  Represents that operation resulted in success.

  It's used in cases when there is no meaningful data to be returned from mutations. The only valid
  value for this scalar is a string "Void".
  """
  scalar :void do
    parse(fn
      "Void" -> {:ok, :void}
      _ -> :error
    end)

    serialize(fn :void -> "Void" end)
  end
end
