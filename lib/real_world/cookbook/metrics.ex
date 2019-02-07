defmodule RealWorld.Metrics do
  use Statix
  def bump_one_lookup() do
    increment("lookups", 1)
  end

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _config) do
    start_time = System.monotonic_time()
    Plug.Conn.register_before_send(conn, &before_send(&1, start_time))
  end

  defp before_send(conn, start_time) do
    end_time = System.monotonic_time()
    histogram("phoenix_exec_time", (end_time - start_time) / 1000)
    conn
  end


  def record_metric(
        %{query_time: query_time, queue_time: queue_time, source: source, query: query} =
          log_entry
      ) do
    process_ecto(source, query_time, queue_time, query)
    log_entry
  end

  def process_ecto(nil, _, _, "begin"), do: :noop
  def process_ecto(nil, _, _, "commit"), do: :noop
  def process_ecto(nil, _, _, "rollback"), do: :noop

  def process_ecto(source, query_time, queue_time, query)
      when is_number(query_time) do
    queue_time = parse_queue_time(queue_time)
    query_exec_time = (query_time + queue_time) / 1000

    histogram("ecto_query_time", query_exec_time)
  end

  defp parse_queue_time(queue_time) when is_number(queue_time), do: queue_time
  defp parse_queue_time(_), do: 0
end
