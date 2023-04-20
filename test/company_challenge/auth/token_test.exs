defmodule CompanyChallenge.Auth.TokenTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Auth.Token
  alias CompanyChallenge.Guardian

  describe "access_for/2" do
    test "return token for email and password" do
      email = "user@someemail.com"
      password = "strongpass"

      client = insert(:client, email: email, password_hash: Bcrypt.hash_pwd_salt(password))

      subject = client.id

      assert {:ok, token, %{"typ" => typ}} = Token.access_for(email, password)

      assert {:ok, %{"typ" => ^typ, "sub" => ^subject}} = Guardian.decode_and_verify(token)
    end

    test "invalid email" do
      _client = insert(:client, password_hash: Bcrypt.hash_pwd_salt("pass"))

      assert Token.access_for("invalid_email", "pass") ==
               {:error, "invalid credentials"}
    end

    test "invalid password" do
      client = insert(:client)

      assert Token.access_for(client.email, "invalid_pass") ==
               {:error, "invalid credentials"}
    end
  end
end
