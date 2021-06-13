defmodule HomebudgetWeb.UserView do
  use HomebudgetWeb, :view

  alias Homebudget.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> List.first()
  end
end
