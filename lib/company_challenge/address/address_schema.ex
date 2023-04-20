defmodule CompanyChallenge.Address.AddressSchema do
  use CompanyChallenge.Schema

  alias Ecto.Changeset
  alias CompanyChallenge.Client.ClientSchema

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "addresses" do
    field(:cep, :string)
    field(:state, :string)
    field(:city, :string)
    field(:number, :string)

    belongs_to(:client, ClientSchema)

    timestamps()
  end

  @params [:cep, :state, :city, :number]
  @optional [:client_id]

  def changeset(%__MODULE__{} = address, params \\ %{}) do
    address
    |> Changeset.cast(params, @params ++ @optional)
    |> Changeset.validate_required(@params)
    |> Changeset.validate_length(:state, max: 255)
    |> Changeset.validate_length(:city, max: 255)
    |> Changeset.validate_length(:cep, is: 8)
    |> Changeset.validate_length(:number, max: 10)
    |> Changeset.unique_constraint(:client_id)
  end
end
