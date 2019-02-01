defmodule RealWorld.Mixfile do
  use Mix.Project

  def project do
    [
      app: :real_world,
      version: "0.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

      # Docs
      name: "RealWorld Example App",
      source_url: "https://github.com/gothinkster/elixir-phoenix-realworld-example-app",
      homepage_url: "https://github.com/gothinkster/elixir-phoenix-realworld-example-app",
      # The main page in the docs
      docs: [main: "RealWorld Example App", logo: "logo.png", extras: ["README.md"]]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RealWorld.Application, []},
      extra_applications: [:logger, :runtime_tools, :comeonin, :statix]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, "~> 0.13.3"},
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_ecto, "~> 0.1.3"},
      {:gettext, "~> 0.11"},
      {:proper_case, "~> 1.0.0"},
      {:cowboy, "~> 1.1"},
      {:comeonin, "~> 3.2"},
      {:guardian, "~> 1.0"},
      {:excoveralls, "~> 0.7", only: [:dev, :test]},
      {:credo, "~> 0.8.5", only: [:dev, :test]},
      {:ex_machina, "~> 2.0", only: :test},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:plug, "~> 1.0"},
      {:corsica, "~> 1.0"},
      {:lager, "~> 3.5", override: true},
      {:statix, ">= 0.0.0"},
      {:cachex, "~> 3.1"},
      #      {:exometer_core, "~> 1.5.7", override: true},
      #      {:exometer_report_statsd, github: "esl/exometer_report_statsd"},
      {:elixometer, github: "pinterest/elixometer"},
      {:decorator, git: "https://github.com/arjan/decorator", ref: "663bd40b54c2fc84"},
      {:spandex, "~> 2.3.0"},
      {:spandex_datadog, "~> 0.3.0"},
      {:parse_trans, "3.2.0", override: true},
      {:httpoison, "~> 1.2", override: true},
      # mix issue:  we might need to change mix.lock to use rebar for setup
      {:setup, "1.8.4", override: true, manager: :rebar, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
