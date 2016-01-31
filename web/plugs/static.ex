defmodule Ginjyo.Plugs.Static do
  use Plug.Builder
  plug Plug.Static, at: "/upload", from: "upload"
  plug Plug.Static, at: "/", from: :ginjyo,
  only: ~w(css fonts images js favicon.ico robots.txt)

end
