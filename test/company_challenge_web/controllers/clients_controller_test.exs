defmodule CompanyChallengeWeb.ClientsControllerTest do
  use CompanyChallengeWeb.ConnCase, async: true

  describe "GET api/clients [:index]" do
    test "return clients list", %{conn: conn} do
      client_one = insert(:client, address: build(:address))
      client_two = insert(:client, address: build(:address))

      client_one_email = client_one.email
      client_two_email = client_two.email

      response =
        conn
        |> get(Routes.clients_path(conn, :index))
        |> json_response(200)

      assert [
               %{
                 "address" => %{
                   "cep" => "012345678",
                   "city" => "São Paulo",
                   "number" => "30",
                   "state" => "São Paulo"
                 },
                 "email" => ^client_one_email,
                 "name" => "Joe Doe",
                 "id" => _id_one
               },
               %{
                 "address" => %{
                   "cep" => "012345678",
                   "city" => "São Paulo",
                   "number" => "30",
                   "state" => "São Paulo"
                 },
                 "email" => ^client_two_email,
                 "name" => "Joe Doe",
                 "id" => _id_two
               }
             ] = response
    end

    test "return empty list", %{conn: conn} do
      response =
        conn
        |> get(Routes.clients_path(conn, :index))
        |> json_response(200)

      assert response == []
    end
  end

  describe "GET api/users/:client_id [:show]" do
    test "returns a client if id is found", %{conn: conn} do
      client = insert(:client)
      client_email = client.email

      response =
        conn
        |> get(Routes.clients_path(conn, :show, client.id))
        |> json_response(200)

      assert %{
               "address" => nil,
               "email" => ^client_email,
               "name" => "Joe Doe",
               "id" => _id
             } = response
    end

    test "resource not found when there's no client", %{conn: conn} do
      client_id = UUID.generate()

      response =
        conn
        |> get(Routes.clients_path(conn, :show, client_id))
        |> json_response(404)

      assert response == %{
               "errors" => "resource not found",
               "message" => "Not found"
             }
    end
  end

  describe "PUT api/users/:client_id [:update]" do
    test "updates client", %{conn: conn} do
      client = insert(:client)

      params = %{
        name: "Updated Name",
        email: "updated@email.com"
      }

      response =
        conn
        |> put(Routes.clients_path(conn, :update, client.id), params)
        |> json_response(200)

      assert %{
               "email" => "updated@email.com",
               "name" => "Updated Name",
               "address" => nil,
               "id" => _id
             } = response
    end

    test "updates client with address", %{conn: conn} do
      client = insert(:client, address: build(:address))

      address = %{
        cep: "01234567",
        state: "Updated State",
        city: "Updated City",
        number: "15"
      }

      params = %{
        name: "Updated Name",
        email: "updated@email.com",
        address: address
      }

      response =
        conn
        |> put(Routes.clients_path(conn, :update, client.id), params)
        |> json_response(200)

      assert %{
               "email" => "updated@email.com",
               "name" => "Updated Name",
               "address" => %{
                 "cep" => "01234567",
                 "city" => "Updated City",
                 "number" => "15",
                 "state" => "Updated State"
               },
               "id" => _id
             } = response
    end

    test "resource not found when there's no client", %{conn: conn} do
      client_id = UUID.generate()

      params = %{
        name: "Updated Name"
      }

      response =
        conn
        |> put(Routes.clients_path(conn, :update, client_id), params)
        |> json_response(404)

      assert response == %{
               "errors" => "resource not found",
               "message" => "Not found"
             }
    end

    test "returns error when breaks email constraint", %{conn: conn} do
      client = insert(:client, email: "email_one@email.com")
      _client_with_email_duplicated = insert(:client, email: "sameemail@email.com")

      params = %{
        email: "sameemail@email.com"
      }

      response =
        conn
        |> put(Routes.clients_path(conn, :update, client.id), params)
        |> json_response(400)

      assert response == %{
               "errors" => %{"email" => ["has already been taken"]},
               "message" => "Bad request"
             }
    end

    test "returns error when params are invalid", %{conn: conn} do
      client = insert(:client)

      params = %{
        email: :not_valid_email,
        name: true,
        address: %{
          cep: false,
          state: 10
        }
      }

      response =
        conn
        |> put(Routes.clients_path(conn, :update, client.id), params)
        |> json_response(400)

      assert response == %{
               "errors" => %{
                 "email" => ["is invalid"],
                 "address" => %{
                   "cep" => ["is invalid"],
                   "city" => ["can't be blank"],
                   "number" => ["can't be blank"],
                   "state" => ["is invalid"]
                 },
                 "name" => ["is invalid"]
               },
               "message" => "Bad request"
             }
    end
  end
end
