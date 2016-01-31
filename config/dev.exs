use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :ginjyo, Ginjyo.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [],
  server: true

# Watch static and templates for browser reloading.
config :ginjyo, Ginjyo.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

  config :logger,
    backends: [
      {LoggerFileBackend, :debug},
      {LoggerFileBackend, :info},
      {LoggerFileBackend, :error},
    ]

  config :logger, :debug,
    path: "log/debug.log",
    level: :debug,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id, :user_id]

  config :logger, :info,
    path: "log/info.log",
    level: :info,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id, :user_id]

  config :logger, :error,
    path: "log/error.log",
    level: :error,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id, :user_id]
    
config :ginjyo,
  schema: "http://"

# Do not include metadata nor timestamps in development logs
#config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :ginjyo, Ginjyo.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "ginjyo_dev",
  hostname: "localhost",
  pool_size: 10
