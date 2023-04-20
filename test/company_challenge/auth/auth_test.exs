defmodule CompanyChallenge.AuthTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Auth

  describe "authentication_for/1" do
    test "return authentication for login an password" do
      email = "fakeemail@email.com"
      password = "$trongPass"

      client =
        insert(:client, email: email, password_hash: Bcrypt.hash_pwd_salt(password), address: nil)

      assert Auth.authentication_for(email, password) == {:ok, client}
    end

    test "wrong password" do
      client = insert(:client)

      assert Auth.authentication_for(client.email, "invalid pass") == {:error, "invalid password"}
    end

    test "login not found" do
      assert Auth.authentication_for("fakemail@outlook.com", "somepass") ==
               {:error, "email not found"}
    end
  end
end
