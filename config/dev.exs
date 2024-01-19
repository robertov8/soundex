import Config

config :logger, :console,
  # level: :debug,
  level: :info,
  format: "[$time] [$level] $message\n"
