defmodule CompanyChallenge.Client.ClientSchema do
  use CompanyChallenge.Schema

  alias CompanyChallenge.Address.AddressSchema
  alias CompanyChallenge.Product.ProductSchema

  schema "clients" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :address, AddressSchema, foreign_key: :client_id, on_replace: :update

    has_many :product, ProductSchema, foreign_key: :client_id

    timestamps()
  end

  @params [:name, :email, :password]

  def changeset(%__MODULE__{} = client, params \\ %{}) do
    client
    |> Changeset.cast(params, @params)
    |> Changeset.validate_required(@params)
    |> default_schema_validations()
  end

  def update_changeset(%__MODULE__{} = client, params \\ %{}) do
    client
    |> Changeset.cast(params, @params)
    |> default_schema_validations()
  end

  defp default_schema_validations(changeset) do
    changeset
    |> Changeset.cast_assoc(:address, with: &AddressSchema.changeset/2)
    |> put_password_hash()
    |> Changeset.validate_length(:name, max: 255)
    |> Changeset.validate_length(:email, max: 255)
    |> Changeset.unique_constraint(:email)
  end

  defp put_password_hash(%{changes: %{password: pwd}} = changeset) do
    Changeset.put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pwd))
  end

  defp put_password_hash(changeset), do: changeset
end
