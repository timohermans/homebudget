defmodule Homebudget.Transactions do
  @moduledoc """
  The Transactions context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias Homebudget.Repo

  alias Homebudget.Transactions.Transaction
  alias Homebudget.Transactions.Account

  def list_transactions(user) do
    Transaction
    |> of_user(user)
    |> Repo.all()
  end

  def get_transaction!(id, user) do
    Transaction
    |> of_user(user)
    |> Repo.get!(id)
  end

  defp of_user(query, %{id: user_id}) do
    query
    |> where([t], t.user_id == ^user_id)
  end

  @type file_path :: String.t()
  @type file_parse_result :: %{failures: integer(), duplicates: integer(), successes: integer()}
  @spec create_transactions_from(
          file_path(),
          Homebudget.Accounts.User.t()
        ) ::
          {:ok, file_parse_result()}
          | {:error, :file_not_found}
          | {:error, :empty_file}
          | {:error, file_parse_result()}
  def create_transactions_from(file_path, user) do
    case File.exists?(file_path) do
      false -> {:error, :file_not_found}
      true -> parse_transaction_file(file_path, user)
    end
  end

  defp parse_transaction_file(file_path, user) do
    parse_report =
      File.stream!(file_path, [{:encoding, :latin1}])
      |> CSV.decode(headers: true)
      |> Stream.map(&persist_accounts_and_transactions(&1, user))
      |> Enum.reduce(%{successes: 0, duplicates: 0, failures: 0}, &add_transaction_result_to_report/2)

    case parse_report do
      %{successes: 0, failures: failures} when failures > 0 -> {:error, parse_report}
      %{successes: 0, duplicates: 0} -> {:error, :invalid_file}
      _ -> {:ok, parse_report}
    end
  end

  defp add_transaction_result_to_report(result, report) do
    case result do
      {:ok, :is_duplicate} ->
        %{report | duplicates: report.duplicates + 1}

      {:ok, _} ->
        %{report | successes: report.successes + 1}

      {:error, :transaction, %Ecto.Changeset{} = changeset, _} ->
        changeset.errors
        |> Enum.reduce(
          "Invalid transaction with the following validation errors: ",
          fn {property, {error, _}}, message ->
            "#{message}#{property}: #{error}, "
          end
        )
        |> Logger.warning()

        %{report | failures: report.failures + 1}

      {:error, _} ->
        %{report | failures: report.failures + 1}
    end
  end

  defp persist_accounts_and_transactions({:error, _ } = error, _user), do: error

  defp persist_accounts_and_transactions({:ok, csv_row}, user) do
    db_transaction = Repo.get_by(Transaction, code: extract_code_from(csv_row))

    if db_transaction == nil do
      Ecto.Multi.new()
      |> Ecto.Multi.run(:receiver, fn repo, _changes ->
        get_or_create_receiver_for(repo, csv_row, user)
      end)
      |> Ecto.Multi.run(:other_party, fn repo, _changes ->
        get_or_create_other_party_for(repo, csv_row, user)
      end)
      |> Ecto.Multi.insert(:transaction, fn %{receiver: receiver, other_party: other_party} ->
        create_transaction_changeset_for(csv_row, receiver, other_party, user)
      end)
      |> Homebudget.Repo.transaction()
    else
      {:ok, :is_duplicate}
    end
  end

  defp extract_code_from(csv_row), do: csv_row["IBAN/BBAN"] <> csv_row["Volgnr"]

  defp get_or_create_receiver_for(repo, csv_row, user) do
    receiver = %{
      name: "Own account",
      account_number: csv_row["IBAN/BBAN"],
      is_user_owner: true,
      user_id: user.id
    }

    db_receiver =
      Account
      |> query_existing_account_by(receiver)
      |> repo.one()

    case db_receiver do
      nil ->
        create_account(receiver)

      %Account{is_user_owner: false} ->
        db_receiver
        |> Account.changeset(%{is_user_owner: true, name: db_receiver.name})
        |> repo.update()

      db_receiver ->
        {:ok, db_receiver}
    end
  end

  defp query_existing_account_by(query, %{account_number: nil, name: account_name}) do
    from(q in query, where: q.name == ^account_name)
  end

  defp query_existing_account_by(query, %{account_number: account_number}) do
    from(q in query, where: q.account_number == ^account_number)
  end

  defp get_or_create_other_party_for(repo, csv_row, user) do
    other_party = %{
      name: csv_row["Naam tegenpartij"],
      account_number: csv_row["Tegenrekening IBAN/BBAN"],
      is_user_owner: false,
      user_id: user.id
    }

    db_other_party =
      Account
      |> query_existing_account_by(other_party)
      |> repo.one()

    # TODO: Test already existing other_party
    case db_other_party do
      nil ->
        create_account(other_party)

      db_other_party ->
        {:ok, db_other_party}
    end
  end

  defp create_transaction_changeset_for(csv_row, receiver, other_party, user) do
    Transaction.changeset(%Transaction{}, %{
      code: extract_code_from(csv_row),
      currency: csv_row["Munt"],
      date: Date.from_iso8601!(csv_row["Datum"]),
      memo:
        "#{csv_row["Omschrijving-1"]} #{csv_row["Omschrijving-2"]} #{csv_row["Omschrijving-3"]}",
      amount:
        csv_row["Bedrag"]
        |> String.replace(",", ".")
        |> Decimal.parse()
        |> elem(0)
    })
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:receiver, receiver)
    |> Ecto.Changeset.put_assoc(:other_party, other_party)
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end

# TODO: report query
# -- select t.date, t.amount, r.name as "to", o.name as "from" from transactions t
# select sum(t.amount)
# left join accounts r on r.id = t.receiver_id
# left join accounts o on o.id = t.other_party_id
# where t.amount < 0 and o.is_user_owner = false;
