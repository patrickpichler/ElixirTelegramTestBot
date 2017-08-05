defmodule BotTest do
  use ExUnit.Case
  doctest Bot.Application

  require OK

  test "OK test" do
    test = %{name: "Hans", age: 32}
    
    result = OK.with do
      try do
        %{name: name, age: 12} = test
        OK.success name

      rescue
        e -> OK.failure e
      end
    end

    IO.inspect result

  end
end