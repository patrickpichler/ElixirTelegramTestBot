defmodule Bot.Commands.Scheduler do
  use Bot.Commander
  import OK, only: ["~>>": 2]

  require OK

  def schedule(update) do
    {:ok, update}
      ~>> extract_text
      ~>> extract_args
      ~>> execute_command(update)
  end

  defp execute_command(["stop"], update) do
    Bot.UserNotifier.stop(get_chat_id())
  end

  defp execute_command(["update", "time", time], update) do
    Bot.UserNotifier.update_time(get_chat_id(), parse_time(time))
  end

  defp execute_command(["update", "message", message], update) do
    Bot.UserNotifier.update_message(get_chat_id(), message)
  end

  defp execute_command([time], update) do
    schedule(parse_time(time), "wat", update)
  end

  defp execute_command([time, message], update) do
    schedule(parse_time(time), message, update)
  end

  defp execute_command(["help"], update)  do
    send_message "halp"
  end

  defp execute_command(args, update) do
    IO.inspect args
  end

  defp parse_time(time) do
    String.to_integer(time) * 1000
  end

  defp schedule(time, message, update) do
    Bot.UserNotifier.start_link(get_chat_id(), time, message)
  end

  defp extract_args(text) do
    [ _ | args] = String.split(text, " ")

    {:ok, args}
  end

  defp extract_text(update) do
    case update do
      %Nadia.Model.Update{
        message: %Nadia.Model.Message{
          text: text
        }
      } -> 
        OK.success text
      _ -> 
        OK.failure :no_match  
    end
  end
end