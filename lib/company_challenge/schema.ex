defmodule CompanyChallenge.Schema do
  defmacro __using__(_opts \\ []) do
    quote do
      use Ecto.Schema

      alias Ecto.Changeset

      @primary_key {:id, Ecto.UUID, autogenerate: true}
      @foreign_key_type Ecto.UUID
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
