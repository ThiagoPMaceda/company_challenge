defmodule CompanyChallengeWeb.ProductsController do
  use CompanyChallengeWeb, :controller

  alias CompanyChallenge.Product
  alias CompanyChallenge.Client.ClientSchema

  def create(
        conn,
        %{
          "name" => _name,
          "price" => _price,
          "description" => _description,
          "image_url" => _image_url
        } = params
      ) do
    %ClientSchema{id: client_id} = Guardian.Plug.current_resource(conn)

    Map.put(params, "client_id", client_id)
    |> create_product()
    |> render_response(conn, :created)
  end

  def create(_conn, _params), do: {:error, :missing_params}

  def index(conn, _params) do
    %ClientSchema{id: client_id} = Guardian.Plug.current_resource(conn)
    render(conn, products: Product.list_all_by_client(client_id))
  end

  def show(conn, %{"id" => product_id}) do
    case Product.get_by_id(product_id) do
      nil ->
        {:error, :resource_not_found}

      product ->
        conn
        |> put_status(:ok)
        |> render(product: product)
    end
  end

  def get_by_client_id(conn, %{"id" => client_id}) do
    render(conn, products: Product.list_all_by_client(client_id))
  end

  def update(conn, %{"id" => product_id} = params) do
    product_id
    |> Product.get_by_id()
    |> update_product(params)
    |> render_response(conn, :ok)
  end

  defp update_product(nil, _params), do: {:error, :resource_not_found}

  defp update_product(client, params) do
    Product.update(client, params)
  end

  defp create_product(params), do: Product.create(params)

  defp render_response({:ok, product}, conn, status) do
    conn |> put_status(status) |> render("product.json", product: product)
  end

  defp render_response({:error, _changeset} = error, _conn, _status), do: error
end
