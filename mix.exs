defmodule HeaderTokenAuth.Mixfile do
  use Mix.Project

  def project do
    [app: :header_token_auth,
     description: "Plug for simple token authentication",
     package: package(),
     version: "1.0.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps()
    ]
  end

  def application do
    [applications: [:logger, :cowboy, :plug]]
  end

  defp deps do
    [
     {:plug, "~> 0.14 or ~> 1.0"},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:credo, ">= 0.0.0", only: [:dev, :test]},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [
      contributors: ["Nick Grysimov"],
      maintainers: ["Nick Grysimov"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/tuned-up/header_token_auth"},
      files: ~w(lib LICENSE.md mix.exs README.md),
    ]
  end
end
