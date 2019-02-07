defmodule EmpexCookbookWeb.TagView do
  use EmpexCookbookWeb, :view

  def render("index.json", %{tags: tags}) do
    %{tags: tags}
  end
end
