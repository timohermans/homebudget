defmodule Homebudget.TransactionsTest do
  use Homebudget.DataCase

  alias Homebudget.Transactions

  describe "accounts" do
    alias Homebudget.Transactions.Account

    @valid_attrs %{account_number: "some account_number", name: "some name"}
    @update_attrs %{account_number: "some updated account_number", name: "some updated name"}
    @invalid_attrs %{account_number: nil, name: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Transactions.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Transactions.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Transactions.create_account(@valid_attrs)
      assert account.account_number == "some account_number"
      assert account.name == "some name"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Transactions.update_account(account, @update_attrs)
      assert account.account_number == "some updated account_number"
      assert account.name == "some updated name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_account(account, @invalid_attrs)
      assert account == Transactions.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Transactions.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Transactions.change_account(account)
    end
  end
end
