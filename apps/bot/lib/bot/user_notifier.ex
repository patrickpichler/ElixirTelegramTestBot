defmodule Bot.UserNotifier do
  use GenServer

  def start_link(chat_id, time, message) do
    name = via_tuple(chat_id)
    GenServer.start_link(__MODULE__, %{chat_id: chat_id, time: time, message: message}, name: name)
  end

  def init(%{time: time} = state) do
    timer_id = schedule_work(time)
    {:ok, %{state | timer_id: timer_id} }
  end

  defp via_tuple(chat_id) do
    {:via, Registry, {:user_notifier_process_registry, chat_id}}
  end

  defp schedule_work(time) do
    Process.send_after(self(), :work, time)
  end

  def update_message(chat_id, new_message) do
    GenServer.cast(via_tuple(chat_id), {:update_message, new_message})
  end

  def update_time(chat_id, time) do
    GenServer.cast(via_tuple(chat_id), {:update_time, time})
  end

  def stop(chat_id) do
    GenServer.stop(via_tuple(chat_id))
  end

  # Server callbacks

  def handle_cast({:update_message, message}, state) do
    {:noreply, %{state | message: message}}
  end

  def handle_cast({:update_time, time}, %{timer_id: old_timer_id} = state) do
    Process.cancel_timer(old_timer_id)

    timer_id = schedule_work(time)

    {:noreply, %{state | time: time, timer_id: timer_id}}
  end

  def handle_info(:work, %{chat_id: chat_id, time: time, message: message} = state) do
    Nadia.send_message(chat_id, message)

    timer_id = schedule_work(time)
    {:noreply, %{state | timer_id: timer_id}}
  end

  def handle_info(_, _) do
  end

end