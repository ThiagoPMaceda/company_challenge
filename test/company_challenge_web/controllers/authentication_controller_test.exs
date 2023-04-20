defmodule CompanyChallengeWeb.AuthenticationControllerTest do
  use CompanyChallengeWeb.ConnCase, async: true

  alias CompanyChallenge.Guardian

  describe "POST api/auth [:create]" do
    test "create access ", %{conn: conn} do
      client =
        insert(:client,
          password_hash: Bcrypt.hash_pwd_salt("strongpass")
        )

      subject = client.id

      params = %{email: client.email, password: "strongpass"}

      response =
        conn
        |> post(Routes.authentication_path(conn, :create), params)
        |> json_response(201)

      assert %{"token" => token} = response
      assert {:ok, %{"typ" => "access", "sub" => ^subject}} = Guardian.decode_and_verify(token)
    end

    test "invalid password", %{conn: conn} do
      client =
        insert(:client,
          password_hash: Bcrypt.hash_pwd_salt("strongpass")
        )

      params = %{email: client.email, password: "invalid password"}

      response =
        conn
        |> post(Routes.authentication_path(conn, :create), params)
        |> json_response(401)

      assert response == %{
               "errors" => %{"authorization" => "invalid credentials"},
               "message" => "Unauthorized"
             }
    end

    test "invalid client email", %{conn: conn} do
      insert(:client, password_hash: Bcrypt.hash_pwd_salt("strongpass"))

      params = %{email: "invalid_login", password: "strongpass"}

      response =
        conn
        |> post(Routes.authentication_path(conn, :create), params)
        |> json_response(401)

      assert response == %{
               "errors" => %{"authorization" => "invalid credentials"},
               "message" => "Unauthorized"
             }
    end

    test "bad request", %{conn: conn} do
      response =
        conn
        |> post(Routes.authentication_path(conn, :create), %{})
        |> json_response(400)

      assert response == %{
               "message" => "Bad request",
               "errors" => "missing parameters"
             }
    end
  end
end
