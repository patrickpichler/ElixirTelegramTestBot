defmodule Bot.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Bot.Poller, []),
      worker(Bot.Matcher, []),
      # supervisor(Registry, [:unique, :user_notifier_process_registry])
    ]

    opts = [strategy: :one_for_one, name: Bot.Supervisor]
    Supervisor.start_link children, opts
  end
end
