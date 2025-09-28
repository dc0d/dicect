defmodule Dicect.MixProject do
  use Mix.Project

  def project do
    [
      app: :dicect,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      test_coverage: [
        summary: [threshold: 0.0001],
        ignore_modules: [
          Dicect.Application,
          Dicect.Lab.Scale,
          Dicect.Lab.Breathless,
          Dicect.Lab.Ironsworn,
          Dicect.Lab.BitD,
          Dicect.Lab.Fate
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dicect.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true},
      {:vega_lite, "~> 0.1", only: [:dev, :test]},
      {:kino, "~> 0.1", only: [:dev, :test]},
      {:tucan, "~> 0.5", only: [:dev, :test]},
      {:kino_vega_lite, "~> 0.1", only: [:dev, :test]}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      compile: ["compile --warning-as-errors"],
      test: ["test --no-start"]
    ]
  end
end
