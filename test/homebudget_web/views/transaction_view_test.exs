defmodule HomebudgetWeb.TransactionViewTest do
  use HomebudgetWeb.ConnCase, async: true

  alias HomebudgetWeb.TransactionView

  describe "sum_actual_incomes/1" do
    test "sums incomes from all actual transactions" do
      user = user_fixture()
      receiver = account_fixture(user)
      other_party = account_fixture(user, %{is_user_owner: false})
      own_account = account_fixture(user, %{is_user_owner: true})

      transactions = [
        transaction_fixture(user, receiver, own_account, %{amount: Decimal.new(70)}),
        transaction_fixture(user, receiver, own_account, %{amount: Decimal.new(-70)}),
        transaction_fixture(user, receiver, other_party, %{amount: Decimal.new("20.11")}),
        transaction_fixture(user, receiver, other_party, %{amount: Decimal.new("25.22")}),
        transaction_fixture(user, receiver, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, receiver, other_party, %{amount: Decimal.new(-100)})
      ]

      assert "65.33" == TransactionView.sum_actual_incomes(transactions)
    end
  end

  describe "sum_actual_expenses/1" do
    test "sums expenses from all transactions not going to own account(s)" do
      user = user_fixture()
      sender = account_fixture(user)
      other_party = account_fixture(user, %{is_user_owner: false})
      own_account = account_fixture(user, %{is_user_owner: true})

      transactions = [
        transaction_fixture(user, sender, own_account, %{amount: Decimal.new(70)}),
        transaction_fixture(user, sender, own_account, %{amount: Decimal.new(-70)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new("-25.25")}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-100)})
      ]

      assert "-125.25" == TransactionView.sum_actual_expenses(transactions)
    end
  end

  describe "sum_actual_balance/1" do
    test "sums the actual balance" do
      user = user_fixture()
      sender = account_fixture(user)
      other_party = account_fixture(user, %{is_user_owner: false})
      own_account = account_fixture(user, %{is_user_owner: true})

      transactions = [
        transaction_fixture(user, sender, own_account, %{amount: Decimal.new(70)}),
        transaction_fixture(user, sender, own_account, %{amount: Decimal.new(-70)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new("-25.25")}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-100)})
      ]

      assert "-85.25" == TransactionView.sum_actual_balance(transactions)
    end
  end

  describe "filter_top_income/1" do
    test "gets the 5 biggest incomes" do
      user = user_fixture()
      sender = account_fixture(user)
      other_party = account_fixture(user, %{is_user_owner: false})

      transactions = [
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(70)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(470)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(170)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(1170)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(2070)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-70)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new("-25.25")}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-100)})
      ]

      # TODO: make it strings and add it to the template
      assert top_transactions = HomebudgetWeb.TransactionView.filter_top_incomes(transactions)
      assert 5 == length(top_transactions)
      assert Decimal.new(2070) == Enum.at(top_transactions, 0).amount
      assert Decimal.new(1170) == Enum.at(top_transactions, 1).amount
      assert Decimal.new(470) == Enum.at(top_transactions, 2).amount
      assert Decimal.new(170) == Enum.at(top_transactions, 3).amount
      assert Decimal.new(70) == Enum.at(top_transactions, 4).amount
    end
  end

  describe "filter_top_expenses/1" do
    test "gets the 5 biggest expenses" do
      user = user_fixture()
      sender = account_fixture(user)
      other_party = account_fixture(user, %{is_user_owner: false})

      transactions = [
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(70)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-470)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-170)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-1170)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-2070)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(20)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-70)}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new("-25.25")}),
        transaction_fixture(user, sender, other_party, %{amount: Decimal.new(-100)})
      ]

      # TODO: make it strings and add it to the template
      assert top_transactions = HomebudgetWeb.TransactionView.filter_top_expenses(transactions)
      assert 5 == length(top_transactions)
      assert Decimal.new(-2070) == Enum.at(top_transactions, 0).amount
      assert Decimal.new(-1170) == Enum.at(top_transactions, 1).amount
      assert Decimal.new(-470) == Enum.at(top_transactions, 2).amount
      assert Decimal.new(-170) == Enum.at(top_transactions, 3).amount
      assert Decimal.new(-100) == Enum.at(top_transactions, 4).amount
    end
  end

  describe "get_title_for/1" do
    test "previous month will display a pretty text" do
      assert "Vorige maand" =
               HomebudgetWeb.TransactionView.get_title_for(Homebudget.Dating.get_previous_month())
    end

    test "this month will display a pretty text" do
      assert "Deze maand" = HomebudgetWeb.TransactionView.get_title_for(Date.utc_today())
    end

    test "other months will display the date" do
      assert "2021-03-01 - 2021-03-31" =
               HomebudgetWeb.TransactionView.get_title_for(~D[2021-03-12])
    end
  end
end
