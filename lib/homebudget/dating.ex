defmodule Homebudget.Dating do
  def get_previous_month() do
    today = Date.utc_today()
    get_previous_month(today)
  end

  def get_previous_month(%Date{} = date) do
    date
    |> Date.beginning_of_month()
    |> Date.add(-1)
    |> Date.beginning_of_month()
  end

  @spec get_next_month(Date.t()) :: Date.t()
  def get_next_month(%Date{} = date) do
    days_this_month = Date.days_in_month(date)

    Date.add(date, days_this_month)
    |> Date.beginning_of_month()
  end
end
