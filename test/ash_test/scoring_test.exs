defmodule AshTest.ScoringTest do
  use AshTest.DataCase

  alias AshTest.Scoring

  describe "checkins" do
    alias AshTest.Scoring.Checkin

    @valid_attrs %{date: ~D[2010-04-17]}
    @update_attrs %{date: ~D[2011-05-18]}
    @invalid_attrs %{date: nil}

    def checkin_fixture(attrs \\ %{}) do
      {:ok, checkin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scoring.create_checkin()

      checkin
    end

#    test "list_checkins/0 returns all checkins" do
#      checkin = checkin_fixture()
#      assert Scoring.list_checkins() == [checkin]
#    end
  end
end
