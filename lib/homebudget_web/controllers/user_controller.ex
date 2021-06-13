defmodule HomebudgetWeb.UserController do
  use HomebudgetWeb, :controller

  alias Homebudget.Accounts
  alias Homebudget.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()

    conn
    |> render("index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    {:ok, user} = Accounts.create_user(user_params)

    conn
    |> put_flash(:info, "#{user.name} created!")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    user =
      id
      |> Integer.parse()
      |> elem(0)
      |> Accounts.get_user()

    conn
    |> render("show.html", user: user)
  end
end
