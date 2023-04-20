defmodule CompanyChallenge.Product.ProductSchema do
  use CompanyChallenge.Schema

  alias CompanyChallenge.Client.ClientSchema

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "products" do
    field :name, :string
    field :price, :integer
    field :description, :string
    field :image_url, :string

    belongs_to :client, ClientSchema

    timestamps()
  end

  @params [:name, :price, :description, :image_url, :client_id]

  def changeset(%__MODULE__{} = product, params \\ %{}) do
    product
    |> Changeset.cast(params, @params)
    |> Changeset.validate_required(@params)
    |> default_schema_validations()
  end

  def update_changeset(%__MODULE__{} = product, params \\ %{}) do
    product
    |> Changeset.cast(params, @params)
    |> default_schema_validations()
  end

  defp default_schema_validations(changeset) do
    changeset
    |> Changeset.validate_length(:name, max: 255)
    |> Changeset.validate_length(:description, max: 255)
    |> Changeset.validate_length(:image_url, max: 255)
    |> Changeset.validate_number(:price, greater_than_or_equal_to: 0)
    |> Changeset.foreign_key_constraint(:client_id)
  end
end
