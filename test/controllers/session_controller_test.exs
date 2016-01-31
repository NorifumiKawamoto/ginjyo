defmodule Ginjyo.SessionControllerTest do
  use Ginjyo.ConnCase

  alias Ginjyo.Factory

  setup do
    user = Factory.create(:user)
    conn = conn()
    {:ok, conn: conn, user: user}
  end

  test "GET /login" do
    conn = get conn, session_path(conn, :new)
    res = html_response(conn, 200)
    assert res =~ "<h2>Login</h2>"
  end

  test "POST /login", %{conn: conn, user: user} do
    conn = post conn,
      session_path(conn, :create),
      session: %{email: user.email, password: user.password}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Sign in successfull!!"
  end
end
