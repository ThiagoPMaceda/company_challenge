defmodule CompanyChallenge.Client do
  alias CompanyChallenge.Repo

  alias CompanyChallenge.Client.ClientSchema

  def get_by_id(client_id) do
    ClientSchema
    |> Repo.get(client_id)
    |> handle_search_or_insert()
  end

  def get_by_email(email) do
    ClientSchema
    |> Repo.get_by(%{email: email})
    |> handle_search_or_insert()
  end

  def list_all() do
    ClientSchema
    |> Repo.all()
    |> Repo.preload(:address)
  end

  def create(params) do
    %ClientSchema{}
    |> ClientSchema.changeset(params)
    |> Repo.insert()
    |> handle_search_or_insert()
  end

  def update(%ClientSchema{} = client, params) do
    client
    |> Repo.preload(:address)
    |> ClientSchema.update_changeset(params)
    |> Repo.update()
  end

  defp handle_search_or_insert({:ok, client}) do
    {:ok, Repo.preload(client, [:address])}
  end

  defp handle_search_or_insert({:error, _changeset} = error), do: error

  defp handle_search_or_insert(client) do
    Repo.preload(client, [:address])
  end
end
