defmodule Homebudget.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal
      add :currency, :string
      add :date, :date
      add :memo, :string

      timestamps()

      add :receiver_id, references(:accounts), null: false
      add :other_party_id, references(:accounts), null: false
    end
  end
end
