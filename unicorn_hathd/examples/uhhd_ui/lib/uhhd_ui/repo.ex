defmodule UhhdUi.Repo do
  use Ecto.Repo,
    otp_app: :uhhd_ui,
    adapter: Ecto.Adapters.Postgres
end
