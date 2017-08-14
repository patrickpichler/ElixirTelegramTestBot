defmodule Bot.Commands.Scheduler do
  use Bot.Commander
  import OK, only: ["~>>": 2]

  require OK

  def schedule(update) do
    {:ok, update}
      ~>> extractText
      ~>> extractArgs
      ~>> executeCommand(update)
  end

  defp executeCommand([time], update) do
    schedule(String.to_integer(time), "wat", update)
  end

  defp executeCommand([time, message], update) do
    schedule(String.to_integer(time), message, update)
  end

  defp schedule(time, message, update) do
    Bot.UserNotifier.start_link(get_chat_id(), time * 1000, message)
  end

  defp executeCommand(["help"], update)  do
    send_message "halp"
  end

  defp executeCommand(args, update) do
    IO.inspect args
  end

  defp extractArgs(text) do
    [ _ | args] = String.split(text, " ")

    {:ok, args}
  end

  defp extractText(update) do
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

  defp handleCommand(command, update)

  defp handleCommand([_command, "help" | _], update) do
    {:ok, _} = send_message("Schedules a message to be send after the given time")
    {:ok, _} = send_message("Usage: `#{command} [time] [message]")
  end

end