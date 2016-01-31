defmodule Ginjyo.PageController do
  use Ginjyo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
