defmodule Ginjyo.Plugs.AllowAdmin do
  use Ginjyo.Web, :controller
  import Plug.Conn
  alias Ginjyo.RoleChecker
  alias Ginjyo.Session

  def init(default), do: default

  def call(conn, _opts) do
    user = Session.current_user(conn)
    if user && RoleChecker.is_admin?(user) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized admin!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
