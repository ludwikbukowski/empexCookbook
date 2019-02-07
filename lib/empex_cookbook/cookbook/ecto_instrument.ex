defmodule EmpexCookbook.EctoInstrument do
  require Logger

  alias EmpexCookbook.Tracing

  defmodule Error do
    defexception [:message]
  end

  def trace(log_entry) do
    try do
      add_tracing(log_entry, "ecto")
    catch
      error ->
        Logger.error("Error occured when tracing ecto. Err: #{inspect(error)}")
    end

    log_entry
  end

  defp start_span(name, start_time, end_time, database) when start_time < end_time do
    create_span(
      name,
      start: start_time,
      completion_time: end_time,
      service: String.to_atom(database)
    )
  end

  defp start_span(_, _, _, _) do
    :ok
  end

  defp create_span(name, opts) do
    Tracing.start_span(name)
    Tracing.update_span(opts)
    Tracing.finish_span()
  end

  defp finish_ecto_trace(%{caller_pid: pid}) do
    Tracing.finish_span()
  end

  defp finish_ecto_trace(_), do: Tracing.finish_span()

  defp add_tracing(%{caller_pid: pid} = log_entry, db) do
    Tracing.start_span(db)
    add_query_spans(log_entry, db)
  end

  defp add_tracing(log_entry, db) do
    Tracing.start_span(db)
    add_query_spans(log_entry, db)
  end

  defp add_query_spans(log_entry, database) do
    now = :os.system_time(:nano_seconds)
    queue_time = get_time(log_entry, :queue_time)
    query_time = get_time(log_entry, :query_time)
    decoding_time = get_time(log_entry, :decode_time)
    start_time = now - (queue_time + query_time + decoding_time)
    query = string_query(log_entry)
    num_rows = num_rows(log_entry)

    Tracing.update_span(
      start: start_time,
      completion_time: now,
      service: String.to_atom(database),
      type: :db,
      sql_query: [
        db: database,
        query: query,
        rows: inspect(num_rows)
      ]
    )

    finish_ecto_trace(log_entry)
  end

  defp string_query(%{query: query}) when is_function(query),
    do: Macro.unescape_string(query.() || "")

  defp string_query(%{query: query}) when is_bitstring(query), do: Macro.unescape_string(query)
  defp string_query(_), do: ""

  defp num_rows(%{result: {:ok, %{num_rows: num_rows}}}), do: num_rows
  defp num_rows(_), do: 0

  defp report_error(%{result: {:ok, _}}), do: :ok

  defp report_error(%{result: {:error, error}}) do
    Tracing.span_error(%Error{message: inspect(error)}, nil)
  end

  def get_time(log_entry, key) do
    value = Map.get(log_entry, key)
    to_nanoseconds(value)
  end

  defp to_nanoseconds(time) when is_integer(time) do
    System.convert_time_unit(time, :native, :nanoseconds)
  end

  defp to_nanoseconds(_), do: 0
end
