defmodule CompanyChallenge.Repo.Migrations.AddProductsTable do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :price, :integer, null: false
      add :description, :string, null: false
      add :image_url, :string, null: false

      timestamps()
    end
  end
end
