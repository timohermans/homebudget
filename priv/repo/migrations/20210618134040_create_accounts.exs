defmodule Homebudget.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :account_number, :string
      add :is_user_owner, :boolean
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:accounts, [:account_number])
    create index(:accounts, [:user_id])
  end
end
