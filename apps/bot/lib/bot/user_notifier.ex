defmodule Bot.UserNotifier do
  use GenServer

  def start_link(chat_id, time, message) do
    name = via_tuple(chat_id)
    GenServer.start_link(__MODULE__, {chat_id, time, message}, name: name)
  end

  def init({_chat_id, time, _message} = state) do
    schedule_work(time)
    {:ok, state}
  end

  defp via_tuple(chat_id) do
    {:via, Registry, {:user_notifier_process_registry, chat_id}}
  end

  defp schedule_work(time) do
    Process.send_after(self(), :work, time)
  end

  # Server Callbacks

  def handle_info(:work, {chat_id, time, message} = state) do
    Nadia.send_message(chat_id, message)

    schedule_work(time)
    {:noreply, state}
  end

end