defmodule RealWorldWeb.AbsintheWithDatadogPlugAPI do
  @behaviour Plug

  def init(opts), do: Absinthe.Plug.init(opts)

  def call(conn, opts) do
    conn
    |> Absinthe.Plug.call(opts)
    |> Spandex.Plug.EndTrace.call(tracer: RealWorld.Tracing, tracer_opts: [])
  end
end
