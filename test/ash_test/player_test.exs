defmodule AshTest.PlayerTest do
  use AshTest.DataCase

  alias AshTest.Scoring
  alias AshTest.Player
  alias AshTest.Habit
  alias Ash.Changeset
  alias AshTest.Api

  describe "player authentication" do

    test "create player without actor" do
      assert {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com"}) |> Api.create()
    end

    test "player creates another player" do
      {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com"}) |> Api.create()
      assert {:error, _} = Changeset.new(Player, %{username: "jono2@gmail.com"}) |> Api.create(actor: player)
    end

    @tag :skip
    test "two players _  one player reads" do
      assert {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com"}) |> Api.create()
      assert {:ok, player2} = Changeset.new(Player, %{username: "jono2@gmail.com"}) |> Api.create()
      assert {:ok, [player]} = Api.read(Player, actor: player)
    end

    test "players modified by another player through the Ash API" do
        assert {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com", field: "test"}) |> Api.create()
        assert {:ok, player2} = Changeset.new(Player, %{username: "jono2@gmail.com"}) |> Api.create()

        assert {:error, player} = Changeset.for_update(player, :default, %{field: "NOPE"}) |> Api.update(actor: player2)
    end

    test "player can create a habit" do
      assert {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com"}) |> Api.create()
      assert {:error, _} = Habit |> Ash.Changeset.new(%{body: "Done ditty Habit"}) |> Api.create()
      assert {:ok, habit} = Habit |> Ash.Changeset.new(%{body: "Done ditty Habit"}) |> Ash.Changeset.replace_relationship(:player, player) |> Api.create()
      assert habit.body == "Done ditty Habit"
    end

    test "player can access habit" do
      assert {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com"}) |> Api.create()
      assert {:ok, habit} = Habit |> Ash.Changeset.new(%{body: "Done ditty Habit"}) |> Ash.Changeset.replace_relationship(:player, player) |> Api.create()
      assert {:ok, [loaded_habit]} = Habit |> Api.read()
      assert habit.body == loaded_habit.body
    end

    test "player can only access their habit" do
      assert {:ok, player} = Changeset.new(Player, %{username: "jono@gmail.com"}) |> Api.create()
      assert {:ok, other_player} = Changeset.new(Player, %{username: "jono2@gmail.com"}) |> Api.create()
      assert {:ok, habit} = Habit |> Changeset.new(%{body: "Done ditty Habit"}) |> Changeset.replace_relationship(:player, player) |> Api.create()
      assert {:ok, _} = Habit |> Changeset.new(%{body: "Done2 ditty Habit"}) |> Changeset.replace_relationship(:player, other_player) |> Api.create()
      assert {:ok, [loaded_habit]} = Habit |> Api.read(actor: player)
#
      assert loaded_habit.body == habit.body
    end
  end


end
