defmodule CompanyChallenge.Guardian do
  use Guardian, otp_app: :company_challenge

  alias CompanyChallenge.Client.ClientSchema

  alias CompanyChallenge.Client

  def subject_for_token(resource, claims \\ %{})

  def subject_for_token(%ClientSchema{id: client_id}, _claims) do
    sub = to_string(client_id)
    {:ok, sub}
  end

  def subject_for_token(_auth, _claims), do: {:error, "an client struct must be given"}

  def resource_from_claims(%{"sub" => client_id}) do
    case Client.get_by_id(client_id) do
      nil -> {:error, "client not found"}
      %ClientSchema{} = client -> {:ok, client}
    end
  end

  def resource_from_claims(_claims), do: {:error, "sub key missing"}
end
