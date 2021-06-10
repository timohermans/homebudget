defmodule Homebudget.Repo do
  use Ecto.Repo,
    otp_app: :homebudget,
    adapter: Ecto.Adapters.Postgres
end
