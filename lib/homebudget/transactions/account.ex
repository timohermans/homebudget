defmodule Homebudget.Transactions.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :account_number, :string
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :account_number])
    |> validate_required([:name, :account_number])
  end
end
