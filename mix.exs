defmodule AnalyticsElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :segment,
      version: "0.1.2",
      elixir: "~> 1.0",
      deps: deps(),
      description: "analytics_elixir",
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:httpoison, :logger, :poison], mod: {Segment, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.12"},
      {:poison, "~> 1.3 or ~> 2.0 or ~> 3.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    # These are the default files included in the package
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Stuart Eccles", "Desmond Bowe", "et al"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/versus-systems/analytics-elixir"}
    ]
  end
end
