# ElixirTelegramBot

Sample Telegram Bot written in Elixir.

## Usage
* Clone the repo
* Run `mix deps.get`
* Create a `config.local.exs` file in the `apps/bot/config` folder with the following content: 
```elixir
use Mix.Config

config :nadia,
  token: "[bot-token]"

config :bot,
  bot_name: "[bot-name]"
```