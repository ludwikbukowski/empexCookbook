defmodule RealWorld.Application do
  @moduledoc false
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    :ok = RealWorld.Metrics.connect()

    opts = [
      host: System.get_env("DATADOG_HOST") || "localhost",
      port: System.get_env("DATADOG_PORT") || 8126,
      batch_size: System.get_env("SPANDEX_BATCH_SIZE") || 1,
      sync_threshold: System.get_env("SPANDEX_SYNC_THRESHOLD") || 100,
      http: HTTPoison
    ]

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(RealWorld.Repo, []),
      worker(Cachex, [:my_cache, []]),
      # Start the endpoint when the application starts
      supervisor(RealWorldWeb.Endpoint, []),
      worker(SpandexDatadog.ApiServer, [opts])
      # Start your own worker by calling: RealWorld.Worker.start_link(arg1, arg2, arg3)
      # worker(RealWorld.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RealWorld.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RealWorldWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
