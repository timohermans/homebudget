defmodule HomebudgetWeb.TransactionControllerTest do
  use HomebudgetWeb.ConnCase

  alias Homebudget.Transactions

  test "placeholder transaction controller test" do
    assert true
  end

  # @create_attrs %{amount: "120.5", currency: "some currency", date: ~D[2010-04-17], memo: "some memo", timestamps: "some timestamps"}
  # @update_attrs %{amount: "456.7", currency: "some updated currency", date: ~D[2011-05-18], memo: "some updated memo", timestamps: "some updated timestamps"}
  # @invalid_attrs %{amount: nil, currency: nil, date: nil, memo: nil, timestamps: nil}

  # def fixture(:transaction) do
  #   {:ok, transaction} = Transactions.create_transaction(@create_attrs)
  #   transaction
  # end

  # describe "index" do
  #   test "lists all transactions", %{conn: conn} do
  #     conn = get(conn, Routes.transaction_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Listing Transactions"
  #   end
  # end

  # describe "new transaction" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.transaction_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Transaction"
  #   end
  # end

  # describe "create transaction" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.transaction_path(conn, :show, id)

  #     conn = get(conn, Routes.transaction_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Transaction"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Transaction"
  #   end
  # end

  # describe "edit transaction" do
  #   setup [:create_transaction]

  #   test "renders form for editing chosen transaction", %{conn: conn, transaction: transaction} do
  #     conn = get(conn, Routes.transaction_path(conn, :edit, transaction))
  #     assert html_response(conn, 200) =~ "Edit Transaction"
  #   end
  # end

  # describe "update transaction" do
  #   setup [:create_transaction]

  #   test "redirects when data is valid", %{conn: conn, transaction: transaction} do
  #     conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs)
  #     assert redirected_to(conn) == Routes.transaction_path(conn, :show, transaction)

  #     conn = get(conn, Routes.transaction_path(conn, :show, transaction))
  #     assert html_response(conn, 200) =~ "some updated currency"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
  #     conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Transaction"
  #   end
  # end

  # describe "delete transaction" do
  #   setup [:create_transaction]

  #   test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
  #     conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
  #     assert redirected_to(conn) == Routes.transaction_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.transaction_path(conn, :show, transaction))
  #     end
  #   end
  # end

  # defp create_transaction(_) do
  #   transaction = fixture(:transaction)
  #   %{transaction: transaction}
  # end
end
