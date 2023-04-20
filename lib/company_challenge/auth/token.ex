defmodule CompanyChallenge.Auth.Token do
  alias CompanyChallenge.Auth
  alias CompanyChallenge.Guardian

  def access_for(email, password) do
    case Auth.authentication_for(email, password) do
      {:ok, auth} -> Guardian.encode_and_sign(auth, %{typ: "access"})
      {:error, _error} -> {:error, "invalid credentials"}
    end
  end
end
