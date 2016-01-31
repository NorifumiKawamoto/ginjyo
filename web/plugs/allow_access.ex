defmodule Ginjyo.Plugs.AllowAccess do
  import Plug.Conn

  def init(default), do: default

  def call(conn, params) do
    case conn.remote_ip do
      {10, 0, _, _} ->
        conn
      {127, 0, 0, 1} ->
        conn
      {192, 168, _, _} ->
        if params == [:localhost] do
          send400 conn
        else
          conn
        end
      _ ->
        if params == [:localhost] or params == [:internal] do
          send400 conn
        else
          conn
        end
    end
  end

  defp send400(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(400, "Bad Request")
  end
end
