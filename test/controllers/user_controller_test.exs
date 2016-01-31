defmodule Ginjyo.UserControllerTest do
  use Ginjyo.ConnCase

  alias Ginjyo.User
  alias Ginjyo.Factory

  @valid_create_attrs %{
    email: "test@test.com",
    password: "test1234",
    password_confirmation: "test1234"
  }
  @valid_attrs %{email: "test@test.com"}
  @invalid_attrs %{email: ""}

  setup do
    user_role     = Factory.create(:role, rank: 0)
    admin_role    = Factory.create(:role, rank: 10)

    nonadmin_user = Factory.create(:user, role: user_role)
    admin_user    = Factory.create(:user, role: admin_role)
    conn = conn()
    {
      :ok,
      conn: conn,
      admin_role: admin_role,
      user_role: user_role,
      nonadmin_user: nonadmin_user,
      admin_user: admin_user
    }
  end

  defp valid_create_attrs(role) do
    Map.put(@valid_create_attrs, :role_id, role.id)
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      session: %{email: user.email, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "redirects from index when not admin",
    %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :index)
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "renders form for new resources",
    %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "redirects from new form when not admin",
    %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :new)
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "creates resource and redirects when data is valid",
  %{conn: conn, user_role: user_role, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create),
      user: valid_create_attrs(user_role)
    assert redirected_to(conn) == user_path(conn, :create)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "redirects from creating user when not admin",
  %{conn: conn, user_role: user_role, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = post conn, user_path(conn, :create),
      user: valid_create_attrs(user_role)
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
    refute Repo.get_by(User, @invalid_attrs)
  end

  test "shows chosen resource when admin",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :show, nonadmin_user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "redirects from show when not admin",
    %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :show, nonadmin_user)
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource when admin",
    %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :edit, admin_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "renders form for editing chosen resource when not admin",
    %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, nonadmin_user)
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "updates chosen resource and redirects when data is valid when logged in as admin",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = put conn, user_path(conn, :update, nonadmin_user), user: @valid_create_attrs
    assert redirected_to(conn) == user_path(conn, :show, nonadmin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource when logged in as a none admin",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, admin_user), user: @valid_create_attrs
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = put conn, user_path(conn, :update, admin_user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
    refute Repo.get_by(User, @invalid_attrs)
  end

  test "deletes chosen resource when logged in admin",
    %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :delete, nonadmin_user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, nonadmin_user.id)
  end

  test "redirects away from deleting chosen resource when logged in as a none admin",
    %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :delete, nonadmin_user)
    assert get_flash(conn, :error) == "You are not authorized admin!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end
end
