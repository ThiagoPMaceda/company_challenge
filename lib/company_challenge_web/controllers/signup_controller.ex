defmodule CompanyChallengeWeb.SignupController do
  use CompanyChallengeWeb, :controller

  alias CompanyChallenge.Client

  def create(conn, %{"name" => _name, "email" => _email, "password" => _password} = params) do
    params
    |> create_client()
    |> render_response(conn, :created)
  end

  def create(_conn, _params), do: {:error, :missing_params}

  defp create_client(params), do: Client.create(params)

  defp render_response({:ok, client}, conn, status) do
    conn |> put_status(status) |> render("client.json", client: client)
  end

  defp render_response({:error, _changeset} = error, _conn, _status), do: error
end
