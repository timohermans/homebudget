defmodule Homebudget.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Homebudget.Transactions.Account

  schema "transactions" do
    field :amount, :decimal
    field :currency, :string
    field :date, :date
    field :memo, :string

    timestamps()

    belongs_to :receiver, Account
    belongs_to :other_party, Account
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :currency, :date, :memo])
    |> validate_required([:amount, :currency, :date, :memo])
  end
end
