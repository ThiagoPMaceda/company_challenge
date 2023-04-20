defmodule CompanyChallengeWeb.FallbackTest do
  use CompanyChallengeWeb.ConnCase, async: true

  alias Ecto.Changeset
  alias CompanyChallengeWeb.Fallback

  describe "auth_error/3" do
    test "unauthenticated error", %{conn: conn} do
      response =
        conn
        |> Fallback.auth_error({:unauthenticated, :unauthenticated}, [])
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" =>
                   "a valid jwt must be given as an authorization header with Bearer realm"
               }
             }
    end

    test "invalid token type", %{conn: conn} do
      response =
        conn
        |> Fallback.auth_error({:invalid_token, "typ"}, [])
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "an access token must be given"
               }
             }
    end

    test "expired token", %{conn: conn} do
      response =
        conn
        |> Fallback.auth_error({:invalid_token, :token_expired}, [])
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "given token is expired"
               }
             }
    end

    test "invalid token format", %{conn: conn} do
      response =
        conn
        |> Fallback.auth_error({:invalid_token, []}, [])
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "token format is invalid, it must be a jwt"
               }
             }
    end

    test "invalid token resource", %{conn: conn} do
      response =
        conn
        |> Fallback.auth_error({:no_resource_found, "user not found"}, [])
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "invalid token resource"
               }
             }
    end
  end

  describe "call/2 [ handle bad request]" do
    test "with a ecto changeset", %{conn: conn} do
      changeset = Changeset.add_error(%Changeset{types: %{}}, :key, "invalid format")

      response =
        conn
        |> Fallback.call({:error, changeset})
        |> json_response(400)

      assert response == %{
               "errors" => %{"key" => ["invalid format"]},
               "message" => "Bad request"
             }
    end

    test "without required params", %{conn: conn} do
      response =
        conn
        |> Fallback.call({:error, :bad_request})
        |> json_response(400)

      assert response == %{"errors" => "missing parameters", "message" => "Bad request"}
    end
  end

  describe "call/2 [ handle Unauthorized when fail to create authentication ]" do
    test "handle authentication error", %{conn: conn} do
      response =
        conn
        |> Fallback.call({:error, "invalid credentials"})
        |> json_response(401)

      assert response == %{
               "message" => "Unauthorized",
               "errors" => %{
                 "authorization" => "invalid credentials"
               }
             }
    end
  end
end
