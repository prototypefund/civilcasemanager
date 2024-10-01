defmodule CaseManager.PassengersTest do
  use CaseManager.DataCase

  alias CaseManager.Passengers

  describe "passengers" do
    alias CaseManager.Passengers.Passenger

    import CaseManager.PassengersFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_passengers/0 returns all passengers" do
      passenger = passenger_fixture()
      assert Passengers.list_passengers() == [passenger]
    end

    test "get_passenger!/1 returns the passenger with given id" do
      passenger = passenger_fixture()
      assert Passengers.get_passenger!(passenger.id) == passenger
    end

    test "create_passenger/1 with valid data creates a passenger" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Passenger{} = passenger} = Passengers.create_passenger(valid_attrs)
      assert passenger.name == "some name"
      assert passenger.description == "some description"
    end

    test "create_passenger/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Passengers.create_passenger(@invalid_attrs)
    end

    test "update_passenger/2 with valid data updates the passenger" do
      passenger = passenger_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Passenger{} = passenger} =
               Passengers.update_passenger(passenger, update_attrs)

      assert passenger.name == "some updated name"
      assert passenger.description == "some updated description"
    end

    test "update_passenger/2 with invalid data returns error changeset" do
      passenger = passenger_fixture()
      assert {:error, %Ecto.Changeset{}} = Passengers.update_passenger(passenger, @invalid_attrs)
      assert passenger == Passengers.get_passenger!(passenger.id)
    end

    test "delete_passenger/1 deletes the passenger" do
      passenger = passenger_fixture()
      assert {:ok, %Passenger{}} = Passengers.delete_passenger(passenger)
      assert_raise Ecto.NoResultsError, fn -> Passengers.get_passenger!(passenger.id) end
    end

    test "change_passenger/1 returns a passenger changeset" do
      passenger = passenger_fixture()
      assert %Ecto.Changeset{} = Passengers.change_passenger(passenger)
    end
  end
end
