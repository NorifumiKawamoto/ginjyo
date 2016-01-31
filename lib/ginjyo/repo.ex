defmodule Ginjyo.Repo do
  use Ecto.Repo, otp_app: :ginjyo
  use Scrivener, page_size: 10
end
