defmodule HomebudgetWeb.TransactionController do
  use HomebudgetWeb, :controller

  alias Homebudget.Transactions

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, user) do
    transactions = Transactions.list_transactions(user)
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params, _user) do
    render(conn, "new.html", result: nil)
  end

  def create(conn, %{"transaction" => %{"file" => file_params}}, user) do
    # TODO: No file given
    # TODO: Error handling
    # TODO: Write happy path test(s)

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
