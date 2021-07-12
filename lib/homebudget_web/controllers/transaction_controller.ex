defmodule HomebudgetWeb.TransactionController do
  use HomebudgetWeb, :controller

  alias Homebudget.Transactions

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, params, user) do
    {:ok, start_date, transactions} = Transactions.list_monthly_transactions(user, params)
    render(conn, "index.html", transactions: transactions, date: start_date)
  end

  def new(conn, _params, _user) do
    render(conn, "new.html", result: nil)
  end

  def create(conn, %{"transaction" => %{"file" => file_params}}, user) do
    case Transactions.create_transactions_from(file_params.path, user) do
      {:ok, %{successes: successes, failures: failures, duplicates: duplicates}} ->
        conn
        |> put_flash(
          :info,
          "Uploaded #{successes} transactions successfully and #{failures} unsuccessfully. There were #{duplicates} duplicates"
        )
        |> redirect(to: Routes.transaction_path(conn, :index))

      {:error, result} ->
        render(conn, "new.html", result: result)
    end
  end

  def show(conn, %{"id" => id}, user) do
    transaction = Transactions.get_transaction!(id, user)
    render(conn, "show.html", transaction: transaction)
  end
end
