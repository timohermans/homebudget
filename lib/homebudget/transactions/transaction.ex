defmodule Homebudget.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :currency, :string
    field :date, :date
    field :memo, :string
    field :timestamps, :string

    timestamps()

    belongs_to :user, Homebudget.Accounts.User
    belongs_to :receiver, Homebudget.Transactions.Account
    belongs_to :other_party, Homebudget.Transactions.Account
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :currency, :memo, :amount, :timestamps])
    |> validate_required([:date, :currency, :memo, :amount, :timestamps])
  end
end
