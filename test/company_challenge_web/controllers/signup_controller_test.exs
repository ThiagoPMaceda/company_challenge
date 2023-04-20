defmodule CompanyChallengeWeb.SignupControllerTest do
  use CompanyChallengeWeb.ConnCase, async: true

  alias CompanyChallenge.Address.AddressSchema
  alias CompanyChallenge.Client.ClientSchema
  alias CompanyChallenge.Repo

  describe "POST api/signup [:create]" do
    test "create client", %{conn: conn} do
      password = "safe_password"

      params = %{
        name: "Joe Doe",
        email: "email@email.com",
        password: password
      }

      response =
        conn
        |> post(Routes.signup_path(conn, :create), params)
        |> json_response(201)

      assert %{
               "email" => "email@email.com",
               "name" => "Joe Doe"
             } = response

      assert Repo.get_by(ClientSchema,
               name: "Joe Doe",
               email: "email@email.com"
             )

      client = Repo.get_by!(ClientSchema, name: "Joe Doe")

      assert Bcrypt.verify_pass(password, client.password_hash)
    end

    test "create client with address", %{conn: conn} do
      password = "safe_password"

      address = %{
        cep: "01234567",
        state: "São Paulo",
        city: "São Paulo",
        number: "15"
      }

      params = %{
        name: "Joe Doe",
        email: "email@email.com",
        password: password,
        address: address
      }

      response =
        conn
        |> post(Routes.signup_path(conn, :create), params)
        |> json_response(201)

      assert %{
               "email" => "email@email.com",
               "name" => "Joe Doe",
               "address" => %{
                 "cep" => "01234567",
                 "state" => "São Paulo",
                 "city" => "São Paulo",
                 "number" => "15"
               }
             } = response

      assert Repo.get_by(ClientSchema,
               name: "Joe Doe",
               email: "email@email.com"
             )

      assert Repo.get_by(
               AddressSchema,
               address
             )
    end

    test "already taken client email", %{conn: conn} do
      existing_client = insert(:client)

      password = "safe_password"

      params = %{
        name: "Joe Doe",
        email: existing_client.email,
        password: password
      }

      response =
        conn
        |> post(Routes.signup_path(conn, :create), params)
        |> json_response(400)

      assert response == %{
               "message" => "Bad request",
               "errors" => %{"email" => ["has already been taken"]}
             }
    end

    test "validation errors", %{conn: conn} do
      params = %{
        name: false,
        email: 10,
        password: :invalid_password,
        address: %{
          cep: false,
          state: 5,
          city: :invalid_city,
          number: :invalid_number
        }
      }

      response =
        conn
        |> post(Routes.signup_path(conn, :create), params)
        |> json_response(400)

      assert response == %{
               "message" => "Bad request",
               "errors" => %{
                 "email" => ["is invalid"],
                 "name" => ["is invalid"],
                 "address" => %{
                   "cep" => ["is invalid"],
                   "city" => ["is invalid"],
                   "number" => ["is invalid"],
                   "state" => ["is invalid"]
                 },
                 "password" => ["is invalid"]
               }
             }
    end

    test "bad request", %{conn: conn} do
      response =
        conn
        |> post(Routes.signup_path(conn, :create), %{})
        |> json_response(400)

      assert response ==
               %{
                 "message" => "Bad request",
                 "errors" => "missing parameters"
               }
    end
  end
end
