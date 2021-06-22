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

  describe "transactions" do
    alias Homebudget.Transactions.Transaction

    @valid_attrs %{amount: "120.5", currency: "some currency", date: ~D[2010-04-17], memo: "some memo", timestamps: "some timestamps"}
    @update_attrs %{amount: "456.7", currency: "some updated currency", date: ~D[2011-05-18], memo: "some updated memo", timestamps: "some updated timestamps"}
    @invalid_attrs %{amount: nil, currency: nil, date: nil, memo: nil, timestamps: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.currency == "some currency"
      assert transaction.date == ~D[2010-04-17]
      assert transaction.memo == "some memo"
      assert transaction.timestamps == "some timestamps"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, @update_attrs)
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.currency == "some updated currency"
      assert transaction.date == ~D[2011-05-18]
      assert transaction.memo == "some updated memo"
      assert transaction.timestamps == "some updated timestamps"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
