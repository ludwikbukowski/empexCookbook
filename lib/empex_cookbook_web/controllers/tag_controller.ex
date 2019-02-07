defmodule EmpexCookbookWeb.TagController do
  use EmpexCookbookWeb, :controller

  alias EmpexCookbook.Cookbook

  action_fallback(EmpexCookbookWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "index.json", tags: Cookbook.list_tags())
  end
end
