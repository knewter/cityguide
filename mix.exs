defmodule Cityguide.Mixfile do
  use Mix.Project

  def project do
    [ 
      app: :cityguide,
      version: "0.0.1",
      deps: deps(Mix.env)
    ]
  end

  def application do
    [
      applications: [
        :inets,
        :hackney
      ],
      mod: {Cityguide, []}
    ]
  end

  defp deps(:prod) do
    [
      { :weber, github: "0xAX/weber" },
      { :current_weather, github: "knewter/current_weather" }
    ]
  end

  defp deps(:test) do
    deps(:prod) ++ [{ :hackney, github: "benoitc/hackney" }]
  end

  defp deps(_) do
    deps(:prod)
  end

end
