# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :company_challenge,
  ecto_repos: [CompanyChallenge.Repo]

# Configures the endpoint
config :company_challenge, CompanyChallengeWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CompanyChallengeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: CompanyChallenge.PubSub,
  live_view: [signing_salt: "aagctWKT"]

config :company_challenge, CompanyChallenge.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id],
  migration_timestamps: [type: :utc_datetime_usec]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :company_challenge, CompanyChallenge.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
