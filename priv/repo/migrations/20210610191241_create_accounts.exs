defmodule Homebudget.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :account_number, :string

      timestamps()
    end

  end
end
