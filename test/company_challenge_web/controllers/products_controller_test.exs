defmodule CompanyChallengeWeb.ProductsControllerTest do
  use CompanyChallengeWeb.ConnCase, async: true

  alias CompanyChallenge.Product.ProductSchema
  alias CompanyChallenge.Repo

  describe "POST api/product [:create]" do
    test "create product", %{conn: conn} do
      client = insert(:client)
      client_id = client.id

      params = %{
        name: "Samsung Galaxy",
        price: 300,
        description: "Cellphone",
        image_url: "fake_url"
      }

      response =
        conn
        |> put_authorization(client)
        |> post(Routes.products_path(conn, :create), params)
        |> json_response(201)

      assert %{
               "name" => "Samsung Galaxy",
               "client_id" => ^client_id,
               "price" => 300,
               "description" => "Cellphone",
               "image_url" => "fake_url",
               "id" => _id
             } = response

      assert Repo.get_by(
               ProductSchema,
               Map.put(params, :client_id, client.id)
             )
    end

    test "unauthorized request", %{conn: conn} do
      params = %{
        name: "Samsung Galaxy",
        price: 300,
        description: "Cellphone",
        image_url: "fake_url"
      }

      response =
        conn
        |> post(Routes.products_path(conn, :create), params)
        |> json_response(401)

      assert response == %{
               "errors" => %{
                 "authorization" =>
                   "a valid jwt must be given as an authorization header with Bearer realm"
               },
               "message" => "Unauthorized"
             }
    end

    test "validation errors", %{conn: conn} do
      client = insert(:client)

      params = %{
        name: 200,
        price: "300",
        description: :invalid_description,
        image_url: 100
      }

      response =
        conn
        |> put_authorization(client)
        |> post(Routes.products_path(conn, :create), params)
        |> json_response(400)

      assert response == %{
               "message" => "Bad request",
               "errors" => %{
                 "name" => ["is invalid"],
                 "description" => ["is invalid"],
                 "image_url" => ["is invalid"]
               }
             }
    end

    test "bad request", %{conn: conn} do
      client = insert(:client)

      response =
        conn
        |> put_authorization(client)
        |> post(Routes.products_path(conn, :create), %{})
        |> json_response(400)

      assert response ==
               %{
                 "message" => "Bad request",
                 "errors" => "missing parameters"
               }
    end
  end

  describe "GET api/products [:index]" do
    test "return products list", %{conn: conn} do
      client = insert(:client)

      insert(:product, client_id: client.id, name: "Keyboard")
      insert(:product, client_id: client.id, name: "Kindle")
      insert(:product, client_id: client.id)

      response =
        conn
        |> put_authorization(client)
        |> get(Routes.products_path(conn, :index))
        |> json_response(200)

      assert [
               %{
                 "description" => "Cellphone",
                 "image_url" => "fake_url",
                 "name" => "Keyboard",
                 "price" => 3000
               },
               %{
                 "description" => "Cellphone",
                 "image_url" => "fake_url",
                 "name" => "Kindle",
                 "price" => 3000
               },
               %{
                 "description" => "Cellphone",
                 "image_url" => "fake_url",
                 "name" => "Iphone",
                 "price" => 3000
               }
             ] = response
    end

    test "return empty list of products", %{conn: conn} do
      client = insert(:client)

      response =
        conn
        |> put_authorization(client)
        |> get(Routes.products_path(conn, :index))
        |> json_response(200)

      assert response == []
    end

    test "unauthorized request", %{conn: conn} do
      response =
        conn
        |> get(Routes.products_path(conn, :index))
        |> json_response(401)

      assert response == %{
               "errors" => %{
                 "authorization" =>
                   "a valid jwt must be given as an authorization header with Bearer realm"
               },
               "message" => "Unauthorized"
             }
    end
  end

  describe "GET api/product/:id [:show]" do
    test "returns a product if id is found", %{conn: conn} do
      client = insert(:client)
      client_id = client.id

      product = insert(:product, client_id: client.id)

      response =
        conn
        |> get(Routes.products_path(conn, :show, product.id))
        |> json_response(200)

      assert %{
               "name" => "Iphone",
               "client_id" => ^client_id,
               "description" => "Cellphone",
               "image_url" => "fake_url",
               "price" => 3000,
               "id" => _id
             } = response
    end

    test "resource not found when there's no product", %{conn: conn} do
      product_id = UUID.generate()

      response =
        conn
        |> get(Routes.clients_path(conn, :show, product_id))
        |> json_response(404)

      assert response == %{
               "errors" => "resource not found",
               "message" => "Not found"
             }
    end
  end

  describe "GET api/user/products/:id [:get_by_client_id]" do
    test "return products list by client id", %{conn: conn} do
      client = insert(:client)

      insert(:product, client_id: client.id, name: "Product One Name")
      insert(:product, client_id: client.id, name: "Product Two Name")
      insert(:product, client_id: client.id)

      response =
        conn
        |> get(Routes.products_path(conn, :get_by_client_id, client.id))
        |> json_response(200)

      assert [
               %{
                 "description" => "Cellphone",
                 "image_url" => "fake_url",
                 "name" => "Product One Name",
                 "price" => 3000
               },
               %{
                 "description" => "Cellphone",
                 "image_url" => "fake_url",
                 "name" => "Product Two Name",
                 "price" => 3000
               },
               %{
                 "description" => "Cellphone",
                 "image_url" => "fake_url",
                 "name" => "Iphone",
                 "price" => 3000
               }
             ] = response
    end

    test "return empty list of products with client id", %{conn: conn} do
      client = insert(:client)

      response =
        conn
        |> get(Routes.products_path(conn, :get_by_client_id, client.id))
        |> json_response(200)

      assert response == []
    end
  end

  describe "PUT api/users/:id [:update]" do
    test "updates product", %{conn: conn} do
      client = insert(:client)
      product = insert(:product, client_id: client.id)

      client_id = client.id

      params = %{
        name: "Updated product name",
        price: 300
      }

      response =
        conn
        |> put_authorization(client)
        |> put(Routes.products_path(conn, :update, product.id), params)
        |> json_response(200)

      assert %{
               "name" => "Updated product name",
               "client_id" => ^client_id,
               "description" => "Cellphone",
               "image_url" => "fake_url",
               "price" => 300,
               "id" => _id
             } = response
    end

    test "resource not found when there's no product", %{conn: conn} do
      client = insert(:client)
      product_id = UUID.generate()

      params = %{
        name: "Updated Name"
      }

      response =
        conn
        |> put_authorization(client)
        |> put(Routes.products_path(conn, :update, product_id), params)
        |> json_response(404)

      assert response == %{
               "errors" => "resource not found",
               "message" => "Not found"
             }
    end

    test "returns error when params are invalid", %{conn: conn} do
      client = insert(:client)

      product = insert(:product, client_id: client.id)

      params = %{
        name: false,
        price: "invalid_price"
      }

      response =
        conn
        |> put_authorization(client)
        |> put(Routes.products_path(conn, :update, product.id), params)
        |> json_response(400)

      assert response == %{
               "errors" => %{"name" => ["is invalid"], "price" => ["is invalid"]},
               "message" => "Bad request"
             }
    end

    test "unauthorized request", %{conn: conn} do
      params = %{
        description: "Cellphone",
        image_url: "fake_url"
      }

      response =
        conn
        |> put(Routes.products_path(conn, :update, UUID.generate()), params)
        |> json_response(401)

      assert response == %{
               "errors" => %{
                 "authorization" =>
                   "a valid jwt must be given as an authorization header with Bearer realm"
               },
               "message" => "Unauthorized"
             }
    end
  end
end
