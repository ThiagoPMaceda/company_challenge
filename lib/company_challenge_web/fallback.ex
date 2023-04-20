defmodule CompanyChallengeWeb.Fallback do
  use Phoenix.Controller

  import Ecto.Changeset, only: [traverse_errors: 2]
  import CompanyChallengeWeb.ErrorHelpers, only: [translate_error: 1]

  alias CompanyChallengeWeb.ErrorView
  alias Ecto.Changeset

  def auth_error(conn, {type, reason}, _opts), do: call(conn, {type, reason})

  def call(conn, {:error, %Changeset{} = error}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", errors: traverse_errors(error, &translate_error/1))
  end

  def call(conn, {:error, "invalid credentials"}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json", errors: %{authorization: "invalid credentials"})
  end

  def call(conn, {:error, :resource_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json", errors: :resource_not_found)
  end

  def call(conn, {:error, _error}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", errors: :missing_params)
  end

  def call(conn, {:unauthenticated, :unauthenticated}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json",
      errors: %{
        authorization: "a valid jwt must be given as an authorization header with Bearer realm"
      }
    )
  end

  def call(conn, {:no_resource_found, _reason}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json", errors: %{authorization: "invalid token resource"})
  end

  def call(conn, {:invalid_token, "typ"}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json", errors: %{authorization: "an access token must be given"})
  end

  def call(conn, {:invalid_token, :token_expired}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json",
      errors: %{authorization: "given token is expired"}
    )
  end

  def call(conn, {:invalid_token, _details}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json",
      errors: %{
        authorization: "token format is invalid, it must be a jwt"
      }
    )
  end
end
