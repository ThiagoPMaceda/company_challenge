defmodule CompanyChallengeWeb.Plugs.AuthenticationTest do
  use CompanyChallengeWeb.ConnCase, async: true

  alias CompanyChallenge.Guardian
  alias CompanyChallenge.Client.ClientSchema
  alias CompanyChallengeWeb.Plugs.Authentication

  describe "authentication pipeline" do
    setup do
      {:ok, options: Authentication.init([])}
    end

    test "valid token", %{conn: conn, options: options} do
      client = insert(:client, address: nil)

      {:ok, token, _claims} = Guardian.encode_and_sign(client, %{"typ" => "access"})

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> Authentication.call(options)

      assert response.state == :unset
      assert Guardian.Plug.current_resource(response) == client
    end

    test "connection without token", %{conn: conn, options: options} do
      response = conn |> Authentication.call(options) |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" =>
                   "a valid jwt must be given as an authorization header with Bearer realm"
               }
             }
    end

    test "token without realm", %{conn: conn, options: options} do
      {:ok, token, _claims} = Guardian.encode_and_sign(%ClientSchema{})

      response =
        conn
        |> put_req_header("authorization", token)
        |> Authentication.call(options)
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" =>
                   "a valid jwt must be given as an authorization header with Bearer realm"
               }
             }
    end

    test "connection with invalid token format", %{conn: conn, options: options} do
      response =
        conn
        |> put_req_header("authorization", "Bearer invalid_string_token")
        |> Authentication.call(options)
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "token format is invalid, it must be a jwt"
               }
             }
    end

    test "wrong token type", %{conn: conn, options: options} do
      {:ok, token, _claims} = Guardian.encode_and_sign(%ClientSchema{}, %{"typ" => "refresh"})

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> Authentication.call(options)
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "an access token must be given"
               }
             }
    end

    test "an expired token", %{conn: conn, options: options} do
      expired_token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJJemFzZWd1cm9zY2hhbGxlbmdlIiwiZXhwIjoxNjU3MjUzNzk3LCJpYXQiOjE2NTcyNTM3OTYsImlzcyI6Ikl6YXNlZ3Vyb3NjaGFsbGVuZ2UiLCJqdGkiOiIzMTdkMjNkYS02NjljLTRjM2QtYWI3OC0yZDYyZDA2MWQ5NWUiLCJuYmYiOjE2NTcyNTM3OTUsInN1YiI6Ijg2OTkwNTBkLTU4NWUtNDI4Zi1iOWM3LTE0YzU2ZjdlZjUzYiIsInR5cCI6ImFjY2VzcyJ9.qVErikweOMv1Az7wNINbpTpg9vVERQz2Y1kwYmdr1nrtgis91yLKNzBbp-6uj8aBhsxZm3SnlJYS0gA1azGJHw"

      response =
        conn
        |> put_req_header("authorization", "Bearer #{expired_token}")
        |> Authentication.call(options)
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "given token is expired"
               }
             }
    end

    test "client not found", %{conn: conn, options: options} do
      {:ok, token, _claims} =
        Guardian.encode_and_sign(%ClientSchema{id: UUID.generate()}, %{
          "typ" => "access"
        })

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> Authentication.call(options)
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "invalid token resource"
               }
             }
    end
  end
end
