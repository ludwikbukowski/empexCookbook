defmodule RealWorld.Decorator do
  use Decorator.Define, tracer: 1

  def tracer(type, body, context) do
    module_name =
      context.module
      |> Module.split()
      |> Enum.join(".")

    quote do
      name = unquote("#{module_name}.#{context.name}/#{context.arity}")
      RealWorld.Tracing.start_span(name)
      RealWorld.Tracing.update_span(service: unquote(type), type: :web)
      value = unquote(body)
      RealWorld.Tracing.finish_span()
      value
    end
  end
end
