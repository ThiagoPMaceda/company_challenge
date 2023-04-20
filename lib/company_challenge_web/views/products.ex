defmodule CompanyChallengeWeb.ProductsView do
  use CompanyChallengeWeb, :view

  def render("index.json", %{products: products}) do
    render_many(products, __MODULE__, "product.json", as: :product)
  end

  def render("get_by_client_id.json", %{products: products}) do
    render_many(products, __MODULE__, "product.json", as: :product)
  end

  def render("create.json", %{product: product}) do
    render_one(product, __MODULE__, "product.json")
  end

  def render("show.json", %{product: product}) do
    render_one(product, __MODULE__, "product.json", as: :product)
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: product.price,
      description: product.description,
      image_url: product.image_url,
      client_id: product.client_id
    }
  end
end
