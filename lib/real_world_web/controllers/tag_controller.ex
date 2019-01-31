defmodule RealWorldWeb.TagController do
  use RealWorldWeb, :controller

  alias RealWorld.Cookbook

  action_fallback(RealWorldWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "index.json", tags: Cookbook.list_tags())
  end
end
