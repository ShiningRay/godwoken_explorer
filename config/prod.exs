import Config

config :godwoken_explorer, GodwokenExplorerWeb.Endpoint,
  # This is critical for ensuring web-sockets properly authorize.
  url: [host: ""],
  root: ".",
  server: true

config :logger,
  backends: [
    :console,
    {LoggerFileBackend, :info},
    {LoggerFileBackend, :error},
    Sentry.LoggerBackend
  ]

# Do not print debug messages in production
config :logger,
  info: [
    path: "log/info.log",
    level: :info,
    format: "$date $time $metadata[$level] $message\n",
    rotate: %{max_bytes: 52_428_800, keep: 19}
  ],
  error: [
    path: "log/error.log",
    level: :error,
    format: "$date $time $metadata[$level] $message\n",
    rotate: %{max_bytes: 52_428_800, keep: 19}
  ]
