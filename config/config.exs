# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ginjyo, Ginjyo.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base:
    "/8cMp2cpmyp97CvmeanlfnwuYUKz6nK4Ouc/M4s8FbSrZuK+vQki/u8mXQ/oU9lC",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Ginjyo.PubSub,
           adapter: Phoenix.PubSub.PG2]


config :ginjyo, Ginjyo.Gettext, default_locale: "ja"

# Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

# SiteInfo
config :ginjyo,
  site_title: "Ginjyo", # your site name
  sub_title: "Blog system", # your site sub title
  site_image: "/images/logo.png",
  description: "It is blog site made by elixir.",
  lang: "ja", # ja, en
  static_path: "priv/static",
  upload_path: "/images/upload/"

# SNS
config :ginjyo,
  twitter: "", # your twitter @account
  facebook: "", # your facebook account
  github: "" # your github account

# Comment
config :ginjyo,
   disqus: "" # your disqus

# Analytics
config :ginjyo,
  google_analytics: "UA-" # Tracking-ID  UA-XXXXXX

# Push notification
config :ginjyo,
  google_push_code: ""

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :scrivener_html,
  routes_helper: Ginjyo.Router.Helpers
