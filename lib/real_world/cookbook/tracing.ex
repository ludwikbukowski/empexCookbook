defmodule RealWorld.Tracing do
  use Spandex.Tracer, otp_app: :datadog
end
