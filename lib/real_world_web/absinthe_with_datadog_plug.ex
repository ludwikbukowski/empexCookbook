defmodule RealWorldWeb.AbsintheWithDatadogPlug do
  @behaviour Plug

  def init(opts), do: Absinthe.Plug.GraphiQL.init(opts)

  def call(conn, opts) do
    conn
    |> Absinthe.Plug.GraphiQL.call(opts)
    |> Spandex.Plug.EndTrace.call(tracer: RealWorld.Tracing, tracer_opts: [])
  end
end
