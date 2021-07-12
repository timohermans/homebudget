defmodule HomebudgetWeb.TransactionControllerTest do
  use HomebudgetWeb.ConnCase, async: true

  # alias Homebudget.Transactions
  # alias Homebudget.Accounts

  describe "without a logged-in user" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.transaction_path(conn, :new)),
          get(conn, Routes.transaction_path(conn, :index)),
          get(conn, Routes.transaction_path(conn, :show, "123")),
          post(conn, Routes.transaction_path(conn, :create, %{}))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "with a logged in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(%{username: username})
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    @tag login_as: "timo"

    test "list all transactions on index", %{conn: conn, user: user} do
      # Arrange
      receiver = account_fixture(user)
      own_account = account_fixture(user)

      jumbo =
        transaction_fixture(user, receiver, account_fixture(user, %{name: "Jumbo Stein"}), %{
          amount: Decimal.new("-10")
        })

      aldi =
        transaction_fixture(user, receiver, account_fixture(user, %{name: "Aldi 005 Stein"}), %{
          amount: -20
        })

      blokker =
        transaction_fixture(
          user,
          receiver,
          account_fixture(user, %{name: "Blokker 0392 Stein LB"}),
          %{amount: -30}
        )

        transaction_fixture(
          user,
          receiver,
          own_account,
          %{amount: 50}
        )

      shortage =
        transaction_fixture(
          user,
          receiver,
          account_fixture(user, %{is_user_owner: true, name: "spaarrekening"}),
          %{amount: 1000}
        )

      # Act
      conn = get(conn, Routes.transaction_path(conn, :index, %{"date" => "2020-01-02"}))

      # Assert
      assert html_response(conn, 200) =~ ~r/2020-01-01 - 2020-01-31/
      assert String.contains?(conn.resp_body, "50.00")
      assert String.contains?(conn.resp_body, "-60.00")
      assert String.contains?(conn.resp_body, "-10.00")
      assert String.contains?(conn.resp_body, jumbo.other_party.name)
      assert String.contains?(conn.resp_body, aldi.other_party.name)
      assert String.contains?(conn.resp_body, blokker.other_party.name)

      refute String.contains?(conn.resp_body, shortage.other_party.name)
    end
  end
end
