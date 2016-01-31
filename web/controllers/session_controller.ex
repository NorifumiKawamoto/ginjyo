defmodule Ginjyo.SessionController do
  use Ginjyo.Web, :controller
  alias Plug.Conn
  alias Ginjyo.Session
  alias Ginjyo.Repo
  require Logger

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Repo) do
      {:ok, user} ->
        Logger.metadata([user_id: user.id])
        conn
        |> Conn.put_session(
        :current_user,
        %{id: user.id, email: user.email, role_id: user.role_id}
        )
        |> put_flash(:info, "Sign in successfull!!")
        |> redirect(to: page_path(conn, :index))
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Conn.delete_session(:current_user)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: page_path(conn, :index))
  end
end
