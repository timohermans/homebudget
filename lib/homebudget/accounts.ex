defmodule Homebudget.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Homebudget.Accounts.User

  def list_users do
    [
      %User{id: 1, name: "Timo Hermans", username: "timo"},
      %User{id: 2, name: "Ryanne Kerkhoffs", username: "ryanne"}
    ]
  end

  def get_user(id) do
    list_users()
    |> Enum.find(&(id == &1.id))
  end

  def get_user_by(params) do
    list_users()
    |> Enum.find(
      &Enum.all?(params, fn {key, value} ->
        Map.get(&1, key) == value
      end)
    )
  end
end
