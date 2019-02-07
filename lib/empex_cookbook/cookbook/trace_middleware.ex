defmodule EmpexCookbook.TraceMiddleware do
  use Spandex.Tracer, otp_app: :datadog

  alias EmpexCookbook.Tracing

  # Called before resolving
  def call(res, _config) do
    Tracing.start_span(res.definition.name)
    Tracing.update_span(%{service: :resolver, tags: [graphql: nil]})
    %{res | middleware: res.middleware ++ [{{__MODULE__, :after_field}, []}]}
  end

  # Called after each resolution to calculate the duration
  def after_field(res, _) do
    Tracing.finish_span()
    res
  end
end
