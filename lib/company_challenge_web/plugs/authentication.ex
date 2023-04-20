defmodule CompanyChallengeWeb.Plugs.Authentication do
  use Guardian.Plug.Pipeline,
    otp_app: :company_challenge,
    module: CompanyChallenge.Guardian,
    error_handler: CompanyChallengeWeb.Fallback

  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
