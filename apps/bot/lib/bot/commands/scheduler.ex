defmodule Bot.Commands.Scheduler do
  use Bot.Commander

  require OK

  def schedule(update) do
    OK.with do
      %Nadia.Model.Update{
        message: %Nadia.Model.Message{
          text: text
        }
      } <- update
    end

    case update do
      %Nadia.Model.Update{
        message: %Nadia.Model.Message{
          text: text
        }
      } -> text
      _ -> "default"
    end
      |> String.split(" ")
      |> IO.inspect
  end

  defp extractText(update) do
    case update do
      %Nadia.Model.Update{
        message: %Nadia.Model.Message{
          text: text
        }
      } -> text
      _ -> "default"
    end
  end

  defp handleCommand(command, update)

  defp handleCommand([_command, "help" | _], update) do
    {:ok, _} = send_message("Schedules a message to be send after the given time")
    {:ok, _} = send_message("Usage: `#{command} [time] [message]")
  end

end