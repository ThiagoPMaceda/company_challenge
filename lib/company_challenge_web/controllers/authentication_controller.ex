defmodule CompanyChallengeWeb.AuthenticationController do
  use CompanyChallengeWeb, :controller

  alias CompanyChallenge.Auth.Token

  def create(conn, %{"email" => email, "password" => password}) do
    render_response(Token.access_for(email, password), conn, :created)
  end

  def create(_conn, _params), do: {:error, :missing_params}

  defp render_response({:error, _error} = error, _conn, _status), do: error

  defp render_response({:ok, token, _claims}, conn, status) do
    conn |> put_status(status) |> render("authentication.json", token: token)
  end
end
