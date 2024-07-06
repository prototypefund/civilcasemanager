defmodule CaseManager.PositionsTest do
  use CaseManager.DataCase

  alias CaseManager.Positions

  describe "positions" do
    alias CaseManager.Positions.Position

    import CaseManager.PositionsFixtures

    @invalid_attrs %{
      id: nil,
      timestamp: nil,
      speed: nil,
      source: nil,
      altitude: nil,
      course: nil,
      heading: nil,
      lat: nil,
      lon: nil,
      imported_from: nil,
      soft_deleted: nil
    }

    test "list_positions/0 returns all positions" do
      position = position_fixture()
      assert Positions.list_positions() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Positions.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      valid_attrs = %{
        id: "some id",
        timestamp: ~U[2024-07-04 16:34:00Z],
        speed: "120.5",
        source: "some source",
        altitude: "120.5",
        course: "120.5",
        heading: "120.5",
        lat: "120.5",
        lon: "120.5",
        imported_from: "some imported_from",
        soft_deleted: true
      }

      assert {:ok, %Position{} = position} = Positions.create_position(valid_attrs)
      assert position.id == "some id"
      assert position.timestamp == ~U[2024-07-04 16:34:00Z]
      assert position.speed == Decimal.new("120.5")
      assert position.source == "some source"
      assert position.altitude == Decimal.new("120.5")
      assert position.course == Decimal.new("120.5")
      assert position.heading == Decimal.new("120.5")
      assert position.lat == Decimal.new("120.5")
      assert position.lon == Decimal.new("120.5")
      assert position.imported_from == "some imported_from"
      assert position.soft_deleted == true
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Positions.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()

      update_attrs = %{
        id: "some updated id",
        timestamp: ~U[2024-07-05 16:34:00Z],
        speed: "456.7",
        source: "some updated source",
        altitude: "456.7",
        course: "456.7",
        heading: "456.7",
        lat: "456.7",
        lon: "456.7",
        imported_from: "some updated imported_from",
        soft_deleted: false
      }

      assert {:ok, %Position{} = position} = Positions.update_position(position, update_attrs)
      assert position.id == "some updated id"
      assert position.timestamp == ~U[2024-07-05 16:34:00Z]
      assert position.speed == Decimal.new("456.7")
      assert position.source == "some updated source"
      assert position.altitude == Decimal.new("456.7")
      assert position.course == Decimal.new("456.7")
      assert position.heading == Decimal.new("456.7")
      assert position.lat == Decimal.new("456.7")
      assert position.lon == Decimal.new("456.7")
      assert position.imported_from == "some updated imported_from"
      assert position.soft_deleted == false
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Positions.update_position(position, @invalid_attrs)
      assert position == Positions.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Positions.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Positions.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Positions.change_position(position)
    end
  end
end
