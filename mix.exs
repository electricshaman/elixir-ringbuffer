defmodule RingBuffer.Mixfile do
  use Mix.Project

  def project do
    [app: :ringbuffer,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:elixir_make] ++ Mix.compilers,
     source_url: "https://github.com/brandonhamilton/elixir-ringbuffer",
     homepage_url: "https://github.com/brandonhamilton/elixir-ringbuffer",
     docs: [extras: ["README.md"]],
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def package do
    [name: :ringbuffer,
     maintainers: ["Brandon Hamilton"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/brandonhamilton/elixir-ringbuffer",
              "Docs" => "https://hexdocs.pm/ringbuffer"}]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev, runtime: false},
     {:elixir_make, "~> 0.4", runtime: false}]
  end
end
