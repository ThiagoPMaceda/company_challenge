import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :company_challenge, CompanyChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "company_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :company_challenge, CompanyChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "a7SuQ25ng6pRu5k1abiIIkLJgZ6xDnOPDRGT52O5MGKEwlM6/C9mMXUsbzWVHZTz",
  server: false

# In test we don't send emails.
config :company_challenge, CompanyChallenge.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Reduce number of round in bcrypt during tests
config :bcrypt_elixir, :log_rounds, 4

config :company_challenge, CompanyChallenge.Guardian,
  issuer: "Companychallenge",
  secret_key: "WEvJGm9FcEQTA0KpUW0fu7YdUVgM/FfbY1JuocLPbJwNFyLAG75xyKqbtoNk/c+P"
