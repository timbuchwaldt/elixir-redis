defmodule Redis.Mixfile do
  use Mix.Project

  def project do
    [ app: :redis,
      version: "1.2.0",
      elixir: ">= 1.0.0",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      { :eredis, "1.0.8", github: "wooga/eredis", tag: "v1.0.8" }
    ]
  end
end
