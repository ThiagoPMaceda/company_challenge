defmodule CompanyChallenge.Product.ProductSchemaTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Product.ProductSchema

  describe "changeset/2" do
    test "return valid changeset" do
      params = %{
        name: "alexa",
        price: 200,
        description: "amazon echo dot",
        image_url: "https://cnd.amazon.com/item?name=alexa",
        client_id: UUID.generate()
      }

      changeset = ProductSchema.changeset(%ProductSchema{}, params)

      assert changeset.valid?
    end

    test "return invalid changeset" do
      params = %{}

      changeset = ProductSchema.changeset(%ProductSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               description: ["can't be blank"],
               image_url: ["can't be blank"],
               name: ["can't be blank"],
               price: ["can't be blank"],
               client_id: ["can't be blank"]
             }
    end

    test "given invalid parameters type" do
      params = %{
        description: 100,
        image_url: false,
        client_id: :invalid_uuid,
        price: :invalid_number,
        name: true
      }

      changeset = ProductSchema.changeset(%ProductSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               client_id: ["is invalid"],
               description: ["is invalid"],
               image_url: ["is invalid"],
               name: ["is invalid"],
               price: ["is invalid"]
             }
    end

    test "handle foreign key constraint" do
      params = %{
        name: "alexa",
        price: 200,
        description: "amazon echo dot",
        image_url: "https://cnd.amazon.com/item?name=alexa",
        client_id: UUID.generate()
      }

      changeset = ProductSchema.changeset(%ProductSchema{}, params)

      assert {:error, result} = Repo.insert(changeset)

      assert errors_on(result) == %{client_id: ["does not exist"]}
    end

    test "fails for bad fields validations" do
      big_string = String.duplicate("a", 256)

      params = %{
        name: big_string,
        price: -1,
        description: big_string,
        image_url: big_string,
        client_id: UUID.generate()
      }

      changeset = ProductSchema.changeset(%ProductSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               description: ["should be at most 255 character(s)"],
               image_url: ["should be at most 255 character(s)"],
               name: ["should be at most 255 character(s)"],
               price: ["must be greater than or equal to 0"]
             }
    end
  end

  describe "update_changeset/2" do
    test "return valid changeset with partial params" do
      params = %{
        name: "alexa",
        price: 200,
        description: "amazon echo dot"
      }

      changeset = ProductSchema.update_changeset(%ProductSchema{}, params)

      assert changeset.valid?
    end

    test "given invalid parameters type" do
      params = %{
        client_id: :invalid_uuid,
        price: :invalid_number
      }

      changeset = ProductSchema.update_changeset(%ProductSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               client_id: ["is invalid"],
               price: ["is invalid"]
             }
    end

    test "handle foreign key constraint" do
      params = %{
        name: "alexa",
        image_url: "https://cnd.amazon.com/item?name=alexa",
        client_id: UUID.generate(),
        price: 10,
        description: "amazon echo dot"
      }

      changeset = ProductSchema.update_changeset(%ProductSchema{}, params)

      assert {:error, result} = Repo.insert(changeset)

      assert errors_on(result) == %{client_id: ["does not exist"]}
    end

    test "fails for bad fields validations" do
      big_string = String.duplicate("a", 256)

      params = %{
        name: big_string,
        price: -1
      }

      changeset = ProductSchema.update_changeset(%ProductSchema{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["should be at most 255 character(s)"],
               price: ["must be greater than or equal to 0"]
             }
    end
  end
end
