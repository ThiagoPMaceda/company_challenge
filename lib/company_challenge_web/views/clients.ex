defmodule CompanyChallengeWeb.ClientsView do
  use CompanyChallengeWeb, :view

  alias CompanyChallengeWeb.AddressView

  def render("index.json", %{clients: clients}) do
    render_many(clients, __MODULE__, "client.json")
  end

  def render("show.json", %{client: client}) do
    render_one(client, __MODULE__, "client.json")
  end

  def render("update.json", %{client: client}) do
    render_one(client, __MODULE__, "client.json")
  end

  def render("client.json", %{clients: client}) do
    %{
      id: client.id,
      name: client.name,
      email: client.email,
      address: render_one(client.address, AddressView, "address.json", as: :address)
    }
  end
end
