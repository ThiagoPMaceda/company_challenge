defmodule CompanyChallenge.Repo.Migrations.ProductBelongsToCompany do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :client_id, references(:clients)
    end
  end
end
