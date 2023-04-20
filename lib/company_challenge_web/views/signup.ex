defmodule CompanyChallengeWeb.SignupView do
  use CompanyChallengeWeb, :view

  alias CompanyChallengeWeb.AddressView

  def render("client.json", %{client: client}) do
    %{
      name: client.name,
      email: client.email,
      address: render_one(client.address, AddressView, "address.json", as: :address)
    }
  end
end
