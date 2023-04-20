defmodule CompanyChallenge.Repo.Migrations.AddEmailUniqueIndexToClient do
  use Ecto.Migration

  def change do
    create unique_index(:clients, [:email])
  end
end
