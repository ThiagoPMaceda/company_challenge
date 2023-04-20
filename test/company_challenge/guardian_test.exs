defmodule CompanyChallenge.GuardianTest do
  use CompanyChallenge.DataCase, async: true

  alias CompanyChallenge.Guardian
  alias CompanyChallenge.Client.ClientSchema

  describe "subject_for_token/2" do
    test "return subject to create token" do
      client_id = UUID.generate()

      assert Guardian.subject_for_token(%ClientSchema{id: client_id}) == {:ok, client_id}
    end

    test "just accept client struct" do
      assert Guardian.subject_for_token(%{client_id: "valid_id"}) ==
               {:error, "an client struct must be given"}
    end
  end

  describe "resource_from_claims/1" do
    test "return a client from sub claim" do
      client = insert(:client, address: nil)

      claims = %{"sub" => client.id}

      assert Guardian.resource_from_claims(claims) == {:ok, client}
    end

    test "client not found" do
      claims = %{"sub" => UUID.generate()}

      assert Guardian.resource_from_claims(claims) == {:error, "client not found"}
    end

    test "claims without sub key" do
      assert Guardian.resource_from_claims(%{}) == {:error, "sub key missing"}
    end
  end
end
