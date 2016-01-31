defmodule Ginjyo.PageControllerTest do
  use Ginjyo.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Ginjyo!"
  end
end
