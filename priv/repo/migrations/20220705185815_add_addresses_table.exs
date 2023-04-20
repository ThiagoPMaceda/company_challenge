defmodule CompanyChallenge.Repo.Migrations.AddAddressesTable do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :cep, :string, null: false
      add :state, :string, null: false
      add :city, :string, null: false
      add :number, :string, null: false

      timestamps()
    end
  end
end
