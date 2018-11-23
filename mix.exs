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

      elixirc_paths: elixirc_paths(Mix.env),

      name: "rsim",
      aliases: aliases(),
      #source_url: "https://github.com/radzserg/rstwitter",
      # homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      #docs: [
      #  main: "RsTwitter", # The main page in the docs
      #  #logo: "path/to/logo.png",
      #  extras: ["README.md"]
      #]
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [
      maintainers: ["Sergey Radzishevskyi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/radzserg/rsim"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [mod: {Rsim.Application, []}, extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_uuid, "~> 1.2"},
      {:poison, "~> 3.0"},
      {:sweet_xml, "~> 0.6"},

      {:ecto, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},

      {:httpoison, "~> 1.4"},

      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},

      # test
      {:mox, "~> 0.4.0", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
