defmodule Homebudget.Accounts.User do
  @type t :: %__MODULE__{
          name: String.t(),
          username: String.t(),
          password: String.t(),
          password_hash: String.t(),
          receiver: Homebudget.Transactions.Account.t(),
          other_party: Homebudget.Transactions.Account.t()
        }

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()

    has_one :receiver, Homebudget.Transactions.Account
    has_one :other_party, Homebudget.Transactions.Account
    has_many :transactions, Homebudget.Transactions.Transaction
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> unique_constraint(:username)
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 2, max: 20)
  end
end
