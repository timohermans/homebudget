defmodule HomebudgetWeb.TransactionView do
  use HomebudgetWeb, :view

  alias Homebudget.Transactions.Transaction

  @spec sum_actual_incomes([Transaction.t()]) :: String.t()
  def sum_actual_incomes(transactions) do
    transactions
    |> Stream.filter(&(Decimal.gt?(&1.amount, 0) and &1.other_party.is_user_owner == false))
    |> Stream.map(& &1.amount)
    |> Enum.reduce(0, &Decimal.add/2)
    |> Decimal.round(2)
    |> Decimal.to_string(:normal)
  end

  @spec sum_actual_expenses([Transaction.t()]) :: String.t()
  def sum_actual_expenses(transactions) do
    transactions
    |> Stream.filter(&(Decimal.lt?(&1.amount, 0) and &1.other_party.is_user_owner == false))
    |> Stream.map(& &1.amount)
    |> Enum.reduce(0, &Decimal.add/2)
    |> Decimal.round(2)
    |> Decimal.to_string(:normal)
  end

  @spec sum_actual_expenses([Transaction.t()]) :: String.t()
  def sum_actual_balance(transactions) do
    with expenses <- Decimal.new(sum_actual_expenses(transactions)),
         incomes <- Decimal.new(sum_actual_incomes(transactions)) do
      Decimal.add(expenses, incomes)
      |> Decimal.round(2)
      |> Decimal.to_string()
    end
  end

  @spec filter_top_incomes([Transaction.t()]) :: String.t()
  def filter_top_incomes(transactions) do
    transactions
    |> Stream.filter(&(Decimal.gt?(&1.amount, 0) and &1.other_party.is_user_owner == false))
    |> Enum.sort(&(&1.amount >= &2.amount))
    |> Enum.take(5)
  end

  @spec filter_top_expenses([Transaction.t()]) :: String.t()
  def filter_top_expenses(transactions) do
    transactions
    |> Stream.filter(&(Decimal.lt?(&1.amount, 0) and &1.other_party.is_user_owner == false))
    |> Enum.sort(&Decimal.lt?(&1.amount, &2.amount))
    |> Enum.take(5)
  end

  @spec get_title_for(Date.t()) :: String.t()
  def get_title_for(date) do
    today = Date.utc_today()
    previous_month = Homebudget.Dating.get_previous_month()

    cond do
      date.month == today.month ->
        "Deze maand"

      date.month == previous_month.month ->
        "Vorige maand"

      true ->
        "#{Date.beginning_of_month(date) |> Date.to_iso8601()} - #{Date.end_of_month(date) |> Date.to_iso8601()}"
    end
  end
end
