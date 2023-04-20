defmodule CompanyChallenge.Address.AddressSchemaTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Address.AddressSchema

  describe "changeset/2" do
    test "return valid changeset" do
      params = %{
        cep: "01234567",
        state: "São Paulo",
        city: "São Paulo",
        number: "30",
        client_id: UUID.generate()
      }

      changeset = AddressSchema.changeset(%AddressSchema{}, params)

      assert changeset.valid?
    end

    test "return invalid changeset" do
      params = %{}

      changeset = AddressSchema.changeset(%AddressSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               cep: ["can't be blank"],
               city: ["can't be blank"],
               number: ["can't be blank"],
               state: ["can't be blank"]
             }
    end

    test "given invalid parameters type" do
      params = %{
        cep: 14,
        city: false,
        client_id: :invalid_uuid,
        number: :invalid_number,
        state: true
      }

      changeset = AddressSchema.changeset(%AddressSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               cep: ["is invalid"],
               city: ["is invalid"],
               client_id: ["is invalid"],
               number: ["is invalid"],
               state: ["is invalid"]
             }
    end

    test "handle unique client" do
      client = insert(:client)
      address = insert(:address, client_id: client.id)

      params = %{
        cep: "01234567",
        state: "São Paulo",
        city: "São Paulo",
        number: "30",
        client_id: address.client_id
      }

      changeset = AddressSchema.changeset(%AddressSchema{}, params)

      assert {:error, result} = Repo.insert(changeset)

      assert errors_on(result) == %{client_id: ["has already been taken"]}
    end

    test "fails for bad fields validations" do
      big_string = String.duplicate("a", 256)

      params = %{
        cep: big_string,
        state: big_string,
        city: big_string,
        number: big_string,
        client_id: UUID.generate()
      }

      changeset = AddressSchema.changeset(%AddressSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               cep: ["should be 8 character(s)"],
               city: ["should be at most 255 character(s)"],
               number: ["should be at most 10 character(s)"],
               state: ["should be at most 255 character(s)"]
             }
    end
  end
end
