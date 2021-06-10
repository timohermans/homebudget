# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :homebudget,
  ecto_repos: [Homebudget.Repo]

# Configures the endpoint
config :homebudget, HomebudgetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U4e2XeltT9H8p7FLFEMfOmRVQIKCCl1jwYNKhnBsT54fvgW7Pm7/gedDhViHaCMK",
  render_errors: [view: HomebudgetWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Homebudget.PubSub,
  live_view: [signing_salt: "e/svASN/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
