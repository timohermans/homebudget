defmodule Homebudget.TestHelpers do
  alias Homebudget.{Accounts, Transactions}

  def fixture_dir_path() do
    Path.expand("fixtures", __DIR__)
  end

  def fixture_file_path(extra) do
    Path.join(fixture_dir_path(), extra)
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "super-secret"
      })
      |> Accounts.register_user()

    user
  end

  def account_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "Some Account",
        account_number: "NL11ABC0123456789",
        is_user_owner: false,
        user_id: user.id
      })

    {:ok, account} = Transactions.create_account(attrs)

    account
  end
end
