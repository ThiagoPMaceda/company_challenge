defmodule CompanyChallengeWeb.ClientsController do
  use CompanyChallengeWeb, :controller

  alias CompanyChallenge.Client

  def index(conn, _params) do
    render(conn, clients: Client.list_all())
  end

  def show(conn, %{"id" => client_id}) do
    case Client.get_by_id(client_id) do
      nil ->
        {:error, :resource_not_found}

      client ->
        conn
        |> put_status(:ok)
        |> render(client: client)
    end
  end

  def update(conn, %{"id" => client_id} = params) do
    client_id
    |> Client.get_by_id()
    |> update_client(params)
    |> render_response(conn)
  end

  defp update_client(nil, _params), do: {:error, :resource_not_found}

  defp update_client(client, params) do
    Client.update(client, params)
  end

  defp render_response({:ok, %{client: client}}, conn) do
    render(conn, client: client)
  end

  defp render_response({:ok, client}, conn) do
    render(conn, client: client)
  end

  defp render_response({:error, _changeset} = error, _conn), do: error
end
