use Mix.Config

config :app,
  bot_name: "SpiskiLiveBot"

config :nadia,
  token: System.get_env("BOT_TOKEN")

import_config "#{Mix.env}.exs"
