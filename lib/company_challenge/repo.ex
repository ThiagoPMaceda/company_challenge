defmodule CompanyChallenge.Repo do
  use Ecto.Repo,
    otp_app: :company_challenge,
    adapter: Ecto.Adapters.Postgres
end
