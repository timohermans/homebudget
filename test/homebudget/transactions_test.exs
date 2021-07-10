defmodule Homebudget.TransactionsTest do
  use Homebudget.DataCase, async: true

  import Ecto.Query, warn: false

  alias Homebudget.Transactions
  alias Homebudget.Transactions.{Transaction, Account}

  describe "create_transactions_from/2" do
    setup do
      %{user: Homebudget.TestHelpers.user_fixture()}
    end

    test "parse a 1 row file into 1 transaction and 2 accounts successfully", %{user: user} do
      single_row_file_path = fixture_file_path("single_dummy.csv")

      assert {:ok, %{successes: 1, duplicates: 0, failures: 0}} =
               Transactions.create_transactions_from(single_row_file_path, user)

      # Assertions
      [transaction] = transactions = list_all_transactions_with_accounts(user)

      assert 1 == length(transactions)
      assert ~D[2019-09-01] == transaction.date
      assert Decimal.new("2.50") == transaction.amount
      assert "NL11RABO0104955555000000000000007213" == transaction.code
      assert "EUR" == transaction.currency
      assert "Spotify 1 2" == transaction.memo
      assert user.id == transaction.user_id

      assert "Own account" == transaction.receiver.name
      assert "NL11RABO0104955555" == transaction.receiver.account_number
      assert "NL42RABO0114164838" == transaction.other_party.account_number
      assert "J.M.G. Kerkhoffs eo" == transaction.other_party.name
    end

    test "parse a 2 row file into 2 transactions and 2 (duplicate) accounts successfully", %{
      user: user
    } do
      multiple_duplicate_accounts_file_path = fixture_file_path("duplicate_account.csv")

      assert {:ok, %{successes: 2, failures: 0, duplicates: 0}} =
               Homebudget.Transactions.create_transactions_from(
                 multiple_duplicate_accounts_file_path,
                 user
               )

      accounts =
        Repo.all(
          from a in Account,
            where: a.user_id == ^user.id
        )

      assert 2 == length(accounts)

      assert Enum.find(
               accounts,
               &(&1.account_number == "NL11RABO0104955555" and &1.is_user_owner == true)
             )

      assert Enum.find(
               accounts,
               &(&1.account_number == "NL42RABO0114164838" and &1.is_user_owner == false)
             )
    end

    test "parse a 3 row file into 2 transactions (1 duplicate) successfully", %{user: user} do
      duplicate_transaction_file_path = fixture_file_path("duplicate_transaction.csv")

      assert {:ok, %{successes: 2, duplicates: 1}} =
               Transactions.create_transactions_from(duplicate_transaction_file_path, user)
    end

    test "returns an error when file is missing", %{user: user} do
      missing_file_path = fixture_file_path("missing_file.csv")

      assert {:error, :file_not_found} =
               Transactions.create_transactions_from(missing_file_path, user)
    end

    test "parse a file with no csv headers returns error", %{user: user} do
      missing_headers_path = fixture_file_path("missing_headers.csv")

      assert {:error, :invalid_file} =
               Transactions.create_transactions_from(missing_headers_path, user)
    end

    test "parse a file with 1 faulty row included returns error", %{user: user} do
      faulty_file_path = fixture_file_path("faulty_transaction.csv")

      assert {:ok, %{ successes: 1, duplicates: 0, failures: 1}} = Transactions.create_transactions_from(faulty_file_path, user)

    end
  end

  defp list_all_transactions_with_accounts(user) do
    Repo.all(
      from t in Transaction,
        where: t.user_id == ^user.id,
        preload: [:receiver, :other_party]
    )
  end
end
