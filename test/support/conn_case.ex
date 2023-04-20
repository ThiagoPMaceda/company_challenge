defmodule CompanyChallengeWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CompanyChallengeWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import CompanyChallengeWeb.ConnCase
      import CompanyChallenge.Factory

      alias CompanyChallengeWeb.Router.Helpers, as: Routes

      alias Ecto.UUID

      defp put_authorization(conn, %CompanyChallenge.Client.ClientSchema{} = auth) do
        {:ok, token, _claims} =
          CompanyChallenge.Guardian.encode_and_sign(auth, %{"typ" => "access"})

        put_req_header(conn, "authorization", "Bearer #{token}")
      end

      # The default endpoint for testing
      @endpoint CompanyChallengeWeb.Endpoint
    end
  end

  setup tags do
    CompanyChallenge.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
