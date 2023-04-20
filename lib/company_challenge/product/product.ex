defmodule CompanyChallenge.Product do
  alias CompanyChallenge.Product.ProductSchema
  alias CompanyChallenge.Repo
  import Ecto.Query

  def create(params) do
    %ProductSchema{}
    |> ProductSchema.changeset(params)
    |> Repo.insert()
  end

  def list_all_by_client(client_id) do
    ProductSchema
    |> where([p], p.client_id == ^client_id)
    |> Repo.all()
  end

  def get_by_id(product_id), do: Repo.get(ProductSchema, product_id)

  def update(%ProductSchema{} = product, params) do
    product
    |> ProductSchema.update_changeset(params)
    |> Repo.update()
  end
end
