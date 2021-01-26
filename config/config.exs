# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ash_test,
  ecto_repos: [AshTest.Repo]

config :mime, :types, %{
  "application/vnd.api+json" => ["json"]
}

# Configures the endpoint
config :ash_test, AshTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s3HxbfpRQVkEqd/JSavIi+t1U6xHgWz298ZRshfMeqzomgYJJIsE/9LVx70wXTGd",
  render_errors: [view: AshTestWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AshTest.PubSub,
  live_view: [signing_salt: "qpZq13uJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
