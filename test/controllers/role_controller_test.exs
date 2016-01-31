defmodule Ginjyo.RoleControllerTest do
  use Ginjyo.ConnCase

  alias Ginjyo.Role
  alias Ginjyo.Factory

  @valid_attrs %{name: "some content", rank: 42}
  @invalid_attrs %{}

  setup do
    conn = conn()
    role = Factory.create(:role, rank: 10)
    admin = Factory.create(:user, role: role)
    conn = post conn,
      session_path(conn, :create),
      session: %{email: admin.email, password: admin.password}
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, role_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing roles"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, role_path(conn, :new)
    assert html_response(conn, 200) =~ "New role"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, role_path(conn, :create), role: @valid_attrs
    assert redirected_to(conn) == role_path(conn, :index)
    assert Repo.get_by(Role, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, role_path(conn, :create), role: @invalid_attrs
    assert html_response(conn, 200) =~ "New role"
  end

  test "shows chosen resource", %{conn: conn} do
    role = Repo.insert! %Role{}
    conn = get conn, role_path(conn, :show, role)
    assert html_response(conn, 200) =~ "Show role"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, role_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    role = Repo.insert! %Role{}
    conn = get conn, role_path(conn, :edit, role)
    assert html_response(conn, 200) =~ "Edit role"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    role = Repo.insert! %Role{}
    conn = put conn, role_path(conn, :update, role), role: @valid_attrs
    assert redirected_to(conn) == role_path(conn, :show, role)
    assert Repo.get_by(Role, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    role = Repo.insert! %Role{}
    conn = put conn, role_path(conn, :update, role), role: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit role"
  end

  test "deletes chosen resource", %{conn: conn} do
    role = Repo.insert! %Role{}
    conn = delete conn, role_path(conn, :delete, role)
    assert redirected_to(conn) == role_path(conn, :index)
    refute Repo.get(Role, role.id)
  end
end
