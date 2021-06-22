defmodule Homebudget.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :date, :date
      add :currency, :string
      add :memo, :string
      add :amount, :decimal
      add :timestamps, :string
      add :other_party_id, references(:accounts, on_delete: :nothing)
      add :receiver_id, references(:accounts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:other_party_id])
    create index(:transactions, [:receiver_id])
    create index(:transactions, [:user_id])
  end
end
