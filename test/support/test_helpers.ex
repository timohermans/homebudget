defmodule Homebudget.TestHelpers do
  alias Homebudget.{Accounts, Transactions}
  alias Homebudget.Transactions.Transaction

  def fixture_dir_path() do
    Path.expand("fixtures", __DIR__)
  end

  def fixture_file_path(extra) do
    Path.join(fixture_dir_path(), extra)
  end

  def transaction_fixture(
        %Accounts.User{} = user,
        %Transactions.Account{} = receiver,
        %Transactions.Account{} = other_party,
        attrs \\ %{}
      ) do
    transaction_attrs =
      attrs
      |> Enum.into(%{
        date: attrs[:date] || ~D[2020-01-16],
        currency: attrs[:currency] || "EUR",
        memo: attrs[:memo] || "Memo",
        amount: attrs[:amount] || Decimal.new("2.50"),
        code: attrs[:code] || generate_random_account_number() <> generate_random_long_number()
      })

    {:ok, transaction} =
      %Transaction{}
      |> Transaction.changeset(transaction_attrs)
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Ecto.Changeset.put_assoc(:receiver, receiver)
      |> Ecto.Changeset.put_assoc(:other_party, other_party)
      |> Homebudget.Repo.insert()

    transaction
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some User",
        username: attrs[:username] || "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "super-secret"
      })
      |> Accounts.register_user()

    user
  end

  def account_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: attrs[:name] || "Some Account: " <> generate_random_string(2),
        account_number: attrs[:account_number] || generate_random_account_number(),
        is_user_owner: attrs[:is_user_owner] || false,
        user_id: user.id
      })

    {:ok, account} = Transactions.create_account(attrs)

    account
  end

  defp generate_random_account_number do
    first_number = for _ <- 1..2, into: "", do: <<Enum.random('123456789')>>
    bank = generate_random_string()
    second_number = generate_random_long_number()
    "NL#{first_number}#{bank}#{second_number}"
  end

  defp generate_random_string(length \\ 4) do
    for _ <- 1..length, into: "", do: <<Enum.random('abcdefghijklmnopqrstuvw')>>
  end

  defp generate_random_long_number do
    for _ <- 1..10, into: "", do: <<Enum.random('123456789')>>
  end
end
