defmodule CompanyChallenge.Auth do
  alias CompanyChallenge.Client

  def authentication_for(email, password) do
    email
    |> get_authentication()
    |> validate_password(password)
  end

  defp get_authentication(email) do
    case Client.get_by_email(email) do
      nil -> {:error, "email not found"}
      auth -> auth
    end
  end

  defp validate_password({:error, _error} = error, _pass), do: error

  defp validate_password(%{} = auth, pass) do
    if Bcrypt.verify_pass(pass, auth.password_hash),
      do: {:ok, auth},
      else: {:error, "invalid password"}
  end
end
