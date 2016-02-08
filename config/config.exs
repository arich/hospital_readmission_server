# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :hospital_readmission_server, HospitalReadmissionServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "hospital_readmission_server_repo",
  username: "ezbc",
  password: "password",
  hostname: "localhost"


# Configures the endpoint
config :hospital_readmission_server, HospitalReadmissionServer.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "OT8zUeXWfcASsjJDpQdbxmFSwGwbbwQ384qzr6s4+UM9DXRciBVLDjbD8U8ap8j5",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: HospitalReadmissionServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
