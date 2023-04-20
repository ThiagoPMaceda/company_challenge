defmodule CompanyChallenge.ProductTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Product
  alias CompanyChallenge.Product.ProductSchema

  describe "create/1" do
    test "create product if received params are valid" do
      client = insert(:client)

      client_id = client.id

      params = %{
        name: "Kindle",
        price: 300,
        description: "description",
        image_url: "fake_url",
        client_id: client.id
      }

      assert {:ok,
              %ProductSchema{
                name: "Kindle",
                price: 300,
                description: "description",
                image_url: "fake_url",
                client_id: ^client_id
              }} = Product.create(params)

      assert Repo.get_by(ProductSchema, %{
               name: "Kindle",
               price: 300,
               description: "description",
               image_url: "fake_url"
             })
    end

    test "returns error client does not exist" do
      params = %{
        name: "Kindle",
        price: 300,
        description: "description",
        image_url: "fake_url",
        client_id: UUID.generate()
      }

      assert {:error, changeset} = Product.create(params)

      assert errors_on(changeset) == %{client_id: ["does not exist"]}
    end

    test "returns error if received params are invalid" do
      params = %{
        name: true,
        price: :invalid_email,
        description: false,
        image_url: 2,
        client_id: UUID.generate()
      }

      assert {:error, changeset} = Product.create(params)

      assert errors_on(changeset) == %{
               name: ["is invalid"],
               description: ["is invalid"],
               image_url: ["is invalid"],
               price: ["is invalid"]
             }
    end
  end

  describe "list_all_by_client/1" do
    test "list products for client" do
      client = insert(:client)

      product_one = insert(:product, client_id: client.id)
      product_two = insert(:product, client_id: client.id)
      product_three = insert(:product, client_id: client.id)

      assert [product_one, product_two, product_three] == Product.list_all_by_client(client.id)
    end

    test "returns empty list if no products are found for client" do
      client = insert(:client)

      another_client = insert(:client)

      _product = insert(:product, client_id: another_client.id)

      assert Product.list_all_by_client(client.id) == []
    end
  end

  describe "get_by_id/1" do
    test "returns product from database" do
      client = insert(:client)

      client_id = client.id

      product =
        insert(:product, name: "Kindle", description: "somedescription", client_id: client_id)

      assert %ProductSchema{name: "Kindle", description: "somedescription", client_id: ^client_id} =
               Product.get_by_id(product.id)
    end

    test "returns nil if product does not exist" do
      assert Product.get_by_id(UUID.generate()) == nil
    end
  end
end
