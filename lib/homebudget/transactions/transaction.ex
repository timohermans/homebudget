defmodule Homebudget.Transactions.Transaction do
  @type t :: %__MODULE__{
          code: String.t(),
          amount: Decimal.t(),
          currency: String.t(),
          date: Date.t(),
          memo: String.t(),
          user: Homebudget.Accounts.User.t(),
          receiver: Homebudget.Transactions.Account.t(),
          other_party: Homebudget.Transactions.Account.t()
        }
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :code, :string
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

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    # TODO: test failing put_assoc
    transaction
    |> cast(attrs, [:code, :date, :currency, :memo, :amount, :user_id])
    |> validate_required([:code, :date, :currency, :amount])
    |> assoc_constraint(:user)
    |> assoc_constraint(:receiver)
    |> assoc_constraint(:other_party)
  end
end
