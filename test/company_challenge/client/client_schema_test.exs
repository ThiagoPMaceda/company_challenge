defmodule CompanyChallenge.Client.ClientSchemaTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Client.ClientSchema

  describe "changeset/2" do
    test "return valid changeset" do
      params = %{
        password: ")y,Aw[*#.01}{my",
        password_hash: "valid_hash",
        name: UUID.generate(),
        email: "teste@teste.com.br"
      }

      changeset = ClientSchema.changeset(%ClientSchema{}, params)

      assert changeset.valid?
    end

    test "generate password hash" do
      params = %{
        password: "{myh&A<(>q3HEze",
        password_hash: "valid_hash",
        name: UUID.generate(),
        email: "teste@teste.com.br"
      }

      changeset = ClientSchema.changeset(%ClientSchema{}, params)

      assert %{password_hash: hash} = changeset.changes
      assert Bcrypt.verify_pass("{myh&A<(>q3HEze", hash)
    end

    test "return invalid changeset" do
      params = %{}

      changeset = ClientSchema.changeset(%ClientSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               email: ["can't be blank"],
               password: ["can't be blank"]
             }
    end

    test "handle unique client email" do
      insert(:client, email: "teste@teste.com.br")

      params = %{
        password: "{myh&A<(>q3HEze",
        name: UUID.generate(),
        email: "teste@teste.com.br"
      }

      changeset = ClientSchema.changeset(%ClientSchema{}, params)

      assert {:error, result} = Repo.insert(changeset)

      assert errors_on(result) == %{
               email: ["has already been taken"]
             }
    end

    test "given invalid parameters type" do
      params = %{
        name: 14,
        email: false,
        password: :invalid_type
      }

      changeset = ClientSchema.changeset(%ClientSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               email: ["is invalid"],
               name: ["is invalid"],
               password: ["is invalid"]
             }
    end

    test "fails for bad fields validations" do
      big_string = String.duplicate("a", 256)

      params = %{
        name: big_string,
        email: big_string,
        password: "valid_password"
      }

      changeset = ClientSchema.changeset(%ClientSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["should be at most 255 character(s)"],
               email: ["should be at most 255 character(s)"]
             }
    end
  end

  describe "update_changeset/2" do
    test "return valid changeset with partial params" do
      params = %{
        name: UUID.generate(),
        email: "teste@teste.com.br"
      }

      changeset = ClientSchema.update_changeset(%ClientSchema{}, params)

      assert changeset.valid?
    end

    test "generate password hash" do
      params = %{
        password: "{myh&A<(>q3HEze",
        password_hash: "valid_hash",
        name: UUID.generate(),
        email: "teste@teste.com.br"
      }

      changeset = ClientSchema.update_changeset(%ClientSchema{}, params)

      assert %{password_hash: hash} = changeset.changes
      assert Bcrypt.verify_pass("{myh&A<(>q3HEze", hash)
    end

    test "handle unique client email" do
      insert(:client, email: "teste@teste.com.br")

      params = %{
        password: "{myh&A<(>q3HEze",
        name: UUID.generate(),
        email: "teste@teste.com.br"
      }

      changeset = ClientSchema.update_changeset(%ClientSchema{}, params)

      assert {:error, result} = Repo.insert(changeset)

      assert errors_on(result) == %{
               email: ["has already been taken"]
             }
    end

    test "given invalid parameters type" do
      params = %{
        name: 14,
        email: false,
        password: :invalid_type
      }

      changeset = ClientSchema.update_changeset(%ClientSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               email: ["is invalid"],
               name: ["is invalid"],
               password: ["is invalid"]
             }
    end

    test "fails for bad fields validations" do
      big_string = String.duplicate("a", 256)

      params = %{
        name: big_string,
        email: big_string,
        password: "valid_password"
      }

      changeset = ClientSchema.update_changeset(%ClientSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["should be at most 255 character(s)"],
               email: ["should be at most 255 character(s)"]
             }
    end
  end
end
