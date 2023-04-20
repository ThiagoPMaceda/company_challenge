defmodule CompanyChallenge.ClientTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Client
  alias CompanyChallenge.Client.ClientSchema

  describe "get_by_id/1" do
    test "returns client from database" do
      client = insert(:client, name: "john", email: "john@email.com")

      assert %ClientSchema{name: "john", email: "john@email.com"} = Client.get_by_id(client.id)
    end

    test "returns nil if client does not exist" do
      assert Client.get_by_id(UUID.generate()) == nil
    end
  end

  describe "get_by_email/1" do
    test "returns one client by email from database" do
      client = insert(:client, email: "john@email.com")

      assert %ClientSchema{email: "john@email.com"} = Client.get_by_email(client.email)
    end

    test "returns nil if client with email does not exist" do
      assert Client.get_by_email("fakeemail@email.com") == nil
    end
  end

  describe "list_all/0" do
    test "returns all clients from database" do
      client_one = insert(:client, email: "clientone@email.com", address: build(:address))
      client_two = insert(:client, email: "clienttwo@email.com", address: build(:address))
      client_three = insert(:client, email: "clienthree@email.com", address: build(:address))

      assert [client_one, client_two, client_three] == Client.list_all()
    end

    test "returns empty list if no clients are found" do
      assert Client.list_all() == []
    end
  end

  describe "create/1" do
    test "create client if received params are valid" do
      params = %{name: "Jane Doe", email: "janedoe@email.com", password: "supersecretpassword"}

      assert {:ok, %ClientSchema{name: "Jane Doe", email: "janedoe@email.com"}} =
               Client.create(params)

      assert Repo.get_by(ClientSchema, %{name: "Jane Doe", email: "janedoe@email.com"})
    end

    test "returns error if received params are invalid" do
      params = %{name: true, email: :invalid_email, password: false}

      assert {:error, changeset} = Client.create(params)

      assert errors_on(changeset) == %{
               email: ["is invalid"],
               name: ["is invalid"],
               password: ["is invalid"]
             }
    end
  end

  describe "update/2" do
    test "update client info successfully" do
      client =
        insert(:client,
          name: "Joe Doe",
          email: "foo@email.com",
          password_hash: Bcrypt.hash_pwd_salt("secret_password")
        )

      params = %{
        name: "Adhan",
        email: "foo@gmail.com",
        password: "strong_pass"
      }

      {:ok, client_updated} = Client.update(client, params)

      assert %ClientSchema{name: "Adhan", email: "foo@gmail.com", password_hash: password_hash} =
               client_updated

      assert Bcrypt.verify_pass("strong_pass", password_hash)
    end

    test "update client with partial info successfully" do
      client =
        insert(:client,
          email: "foo@email.com"
        )

      params = %{
        email: "updated_email@email.com"
      }

      {:ok, client_updated} = Client.update(client, params)

      assert %ClientSchema{email: "updated_email@email.com"} = client_updated
    end

    test "update client info when address is in params" do
      client =
        insert(:client,
          name: "Joe Doe",
          email: "foo@email.com",
          password_hash: Bcrypt.hash_pwd_salt("secret_password")
        )

      params = %{
        name: "Adhan",
        email: "foo@gmail.com",
        password: "strong_pass",
        address: %{
          cep: "11111111",
          state: "updated state",
          city: "updated city",
          number: "01"
        }
      }

      {:ok, client_updated} = Client.update(client, params)

      assert %ClientSchema{
               name: "Adhan",
               email: "foo@gmail.com",
               address: %{
                 cep: "11111111",
                 state: "updated state",
                 city: "updated city",
                 number: "01"
               }
             } = client_updated
    end

    test "given an invalid client params returns error" do
      client = insert(:client)

      params = %{email: :invalid_email}

      {:error, changeset} = Client.update(client, params)

      refute changeset.valid?
    end

    test "given an already registered email returns error" do
      client = insert(:client, email: "email@email.com")

      insert(:client, email: "emailduplicate@email.com")

      params = %{email: "emailduplicate@email.com"}

      {:error, result} = Client.update(client, params)

      refute result.valid?

      assert errors_on(result) == %{
               email: ["has already been taken"]
             }
    end
  end
end
