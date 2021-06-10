defmodule HomebudgetWeb.PageController do
  use HomebudgetWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
