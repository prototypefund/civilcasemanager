defmodule CaseManager.PlacesTest do
  use CaseManager.DataCase

  alias CaseManager.Places

  describe "places" do
    alias CaseManager.Places.Place

    import CaseManager.PlacesFixtures

    @invalid_attrs %{name: nil, type: nil, country: nil, lat: nil, lon: nil}

    test "get_place!/1 returns the place with given name" do
      place = place_fixture()
      assert Places.get_place!(place.id) == place
    end

    test "create_place/1 with valid data creates a place" do
      valid_attrs = %{
        name: "some name",
        type: :departure,
        country: "some country",
        lat: "120.5",
        lon: "120.5"
      }

      assert {:ok, %Place{} = place} = Places.create_place(valid_attrs)
      assert place.name == "some name"
      assert place.type == :departure
      assert place.country == "some country"
      assert place.lat == Decimal.new("120.5")
      assert place.lon == Decimal.new("120.5")
    end

    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Places.create_place(@invalid_attrs)
    end

    test "update_place/2 with valid data updates the place" do
      place = place_fixture()

      update_attrs = %{
        type: :arrival,
        country: "some updated country",
        lat: "456.7",
        lon: "456.7"
      }

      assert {:ok, %Place{} = place} = Places.update_place(place, update_attrs)
      assert place.name == place.name
      assert place.type == :arrival
      assert place.country == "some updated country"
      assert place.lat == Decimal.new("456.7")
      assert place.lon == Decimal.new("456.7")
    end

    test "update_place/2 with invalid data returns error changeset" do
      place = place_fixture()
      assert {:error, %Ecto.Changeset{}} = Places.update_place(place, @invalid_attrs)
      assert place == Places.get_place!(place.id)
    end

    test "delete_place/1 deletes the place" do
      place = place_fixture()
      assert {:ok, %Place{}} = Places.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Places.get_place!(place.id) end
    end

    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Places.change_place(place)
    end
  end
end
