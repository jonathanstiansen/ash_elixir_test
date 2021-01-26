defmodule AshTest.Api do
  use Ash.Api

  resources do
    resource AshTest.Player
    resource AshTest.Habit
  end
end
