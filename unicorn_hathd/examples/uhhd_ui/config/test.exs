use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :uhhd_ui, UhhdUiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :uhhd_ui, UhhdUi.Repo,
  username: "postgres",
  password: "postgres",
  database: "uhhd_ui_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
