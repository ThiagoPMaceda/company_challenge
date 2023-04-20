defmodule CompanyChallengeWeb.AuthenticationView do
  use CompanyChallengeWeb, :view

  def render("authentication.json", %{token: token}), do: %{token: token}
end
