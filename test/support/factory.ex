defmodule CompanyChallenge.Factory do
  use ExMachina.Ecto, repo: CompanyChallenge.Repo

  alias CompanyChallenge.Address.AddressSchema
  alias CompanyChallenge.Client.ClientSchema
  alias CompanyChallenge.Product.ProductSchema

  def client_factory do
    %ClientSchema{
      name: "Joe Doe",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: Bcrypt.hash_pwd_salt("1234512345")
    }
  end

  def client_with_address_factory do
    %ClientSchema{
      name: "Joe Doe",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: Bcrypt.hash_pwd_salt("1234512345"),
      address: build(:address)
    }
  end

  def address_factory do
    %AddressSchema{
      cep: "012345678",
      state: "São Paulo",
      city: "São Paulo",
      number: "30",
      client_id: Ecto.UUID.generate()
    }
  end

  def product_factory do
    %ProductSchema{
      name: "Iphone",
      price: 3000,
      description: "Cellphone",
      image_url: "fake_url",
      client_id: Ecto.UUID.generate()
    }
  end
end
