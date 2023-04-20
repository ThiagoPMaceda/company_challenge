defmodule CompanyChallengeWeb.AddressView do
  use CompanyChallengeWeb, :view

  def render("address.json", %{address: address}) do
    %{
      cep: address.cep,
      state: address.state,
      city: address.city,
      number: address.number
    }
  end
end
