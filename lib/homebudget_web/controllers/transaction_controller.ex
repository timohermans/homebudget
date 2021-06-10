defmodule HomebudgetWeb.TransactionController do
  use HomebudgetWeb, :controller

  def upload(conn, _params) do
    render(conn, "upload.html")
  end
end
