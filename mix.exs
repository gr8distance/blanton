defmodule Blanton.MixProject do
  use Mix.Project

  def project do
    [
      app: :blanton,
      version: "0.1.2",
      elixir: "~> 1.10",
      description: "Blanton is a BigQuery library written by Elixir.",
      start_permanent: Mix.env() == :prod,
      package: [
        maintainers: ["gr8distance"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/gr8distance/blanton"}
      ],
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:google_api_big_query, "~> 0.41"},
      {:goth, "~> 1.1.0"},
      {:jason, "~> 1.2"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end
end
