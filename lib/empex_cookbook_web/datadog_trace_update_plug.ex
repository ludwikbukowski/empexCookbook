defmodule EmpexCookbookWeb.DatadogTraceUpdatePlug do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _config) do
    IO.inspect(conn)
    query = conn.body_params["query"]
    res = parse_query(query)
    update_datadog_trace(conn, res)
  end

  defp update_datadog_trace(conn, {:ok, type, name}) do
    Spandex.Plug.AddContext.call(conn,
      tracer: EmpexCookbook.Tracing,
      disallowed_route_replacements: [],
      tracer_opts: [resource: :"#{type}.#{name}"]
    )
  end

  defp update_datadog_trace(conn, {:error, _}), do: conn

  def parse_query(query) when is_binary(query) do
    case Regex.named_captures(~r/(?<type>mutation|query)[^{]*{\s*(?<name>\w+)/, query) do
      %{"type" => type, "name" => name} ->
        {:ok, type, name}

      _ ->
        {:error, "no match"}
    end
  end

  def parse_query(_), do: {:error, "no match"}
end
