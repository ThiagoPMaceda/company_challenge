defmodule CompanyChallenge.Repo.Migrations.AddClientsTable do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end
  end
end
