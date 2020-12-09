defmodule App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.3",
      default_task: "server",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :logger_file_backend, :nadia, :poison, :redix],
      mod: {App, []}
    ]
  end

  defp deps do
    [
      {:nadia, "~> 0.6.0"},
      {:poison, "~> 3.1"},
      {:redix, ">= 0.0.0"},
      {:castore, ">= 0.0.0"},
      {:httpoison, "~> 1.6.2"},
      {:logger_file_backend, "~> 0.0.11"}
    ]
  end

  defp aliases do
    [server: "run --no-halt"]
  end
end
