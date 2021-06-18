defmodule HomebudgetWeb.SessionController do
  use HomebudgetWeb, :controller

  alias Homebudget.Accounts

  def new(conn, _) do
    # TODO: test
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    # TODO: test
    case Accounts.authenticate_by_username_and_password(username, password) do
      {:ok, user} ->
        conn
        |> HomebudgetWeb.Auth.login(user)
        |> put_flash(:info, "logged in!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid username or password. I'm sorry 😔")
        |> render("new.html")
    end
  end

  def delete(conn, %{"id" => _}) do
    # TODO: test
    conn
    |> HomebudgetWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
