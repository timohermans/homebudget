defmodule Homebudget.Transactions.Account do
  @type t :: %__MODULE__{
          name: String.t(),
          account_number: String.t(),
          user: Homebudget.Accounts.User.t()
        }

  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :account_number, :string
    field :name, :string
    field :is_user_owner, :boolean

    timestamps()

    belongs_to :user, Homebudget.Accounts.User
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :account_number, :is_user_owner, :user_id])
    |> validate_required([:name])
    |> unique_constraint([:account_number])
    |> assoc_constraint(:user)
  end
end
