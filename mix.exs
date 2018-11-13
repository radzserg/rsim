defmodule Rsim.MixProject do
  use Mix.Project

  def project do
    [
      app: :rsim,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),


      description: "Image manager",
      package: package(),
      source_url: "https://github.com/radzserg/rsim",

      name: "RSIM",
      #source_url: "https://github.com/radzserg/rstwitter",
      # homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      #docs: [
      #  main: "RsTwitter", # The main page in the docs
      #  #logo: "path/to/logo.png",
      #  extras: ["README.md"]
      #]
    ]
  end

  defp package do
    [
      maintainers: ["Sergey Radzishevskyi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/radzserg/rsim"}
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
      {:httpoison, "~> 1.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
