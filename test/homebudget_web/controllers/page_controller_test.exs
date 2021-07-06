defmodule HomebudgetWeb.PageControllerTest do
  use HomebudgetWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to HomeBudget!"
  end
end
