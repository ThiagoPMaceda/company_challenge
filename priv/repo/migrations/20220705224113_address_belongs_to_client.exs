defmodule CompanyChallenge.Repo.Migrations.AddressBelongsToClient do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :client_id, references(:clients), null: false
    end

    create unique_index(:addresses, [:client_id])
  end
end
