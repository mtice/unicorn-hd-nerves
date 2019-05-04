defmodule LineRotate.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :line_rotate,
      version: "0.1.0",
      elixir: "~> 1.8",
      target: @target,
      archives: [nerves_bootstrap: "~> 1.5"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LineRotate.Application, []},
      extra_applications: [:logger, :runtime_tools, :unicorn_hathd]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},

      # Dependencies for all targets except :host
      {:unicorn_hathd, path: "../../"},
      {:nerves_runtime, "~> 0.6"},
      {:nerves_init_gadget, "~> 0.6"},
      {:phoenix_client, "~> 0.7"},
      {:websocket_client, "~> 1.3"},
      {:jason, "~> 1.0"},

      # Dependencies for specific targets
      {:nerves_system_rpi, "~> 1.6", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.6", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.6", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 1.6", runtime: false, targets: :rpi3},
      {:nerves_system_rpi3a, "~> 1.6", runtime: false, targets: :rpi3a},
      {:nerves_system_bbb, "~> 2.0", runtime: false, targets: :bbb},
      {:nerves_system_x86_64, "~> 1.6", runtime: false, targets: :x86_64},
    ]
  end
end
