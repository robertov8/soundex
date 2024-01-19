defmodule Soundex.MixProject do
  use Mix.Project

  def project do
    [
      app: :soundex,
      version: "0.1.0",
      elixir: "~> 1.15",
      name: "Soundex",
      source_url: "https://github.com/robertov8/soundex",
      description: "An implementation of the Soundex algorithm in Elixir.",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.cobertura": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :wx, :observer, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "soundex",
      files: ~w(lib/soundex.ex .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/robertov8/soundex"}
    ]
  end
end
