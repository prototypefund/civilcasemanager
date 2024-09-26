defmodule CaseManagerWeb.ExtendedComponentsTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  alias CaseManagerWeb.ExtendedComponents
  alias CaseManager.CaseNationalities.CaseNationality

  describe "filter_form/1" do
    test "renders form with correct attributes" do
      fields = [:name]
      meta = %Flop.Meta{}

      html = render_component(&ExtendedComponents.filter_form/1, %{fields: fields, meta: meta})

      assert html =~ ~s(phx-change="update-filter")
      assert html =~ ~s(class="grid grid-cols-2 gap-x-4 gap-y-2")
      assert html =~ ~s(phx-debounce="150")
    end
  end

  describe "nationalities_summary/1" do
    test "renders 'None' when nationalities list is empty" do
      html = render_component(&ExtendedComponents.nationalities_summary/1, %{nationalities: []})
      assert html =~ "None"
    end

    test "renders nationalities with counts" do
      nationalities = [
        %CaseNationality{country: "TN", count: 5},
        %CaseNationality{country: "SY", count: 3}
      ]

      html =
        render_component(&ExtendedComponents.nationalities_summary/1, %{
          nationalities: nationalities
        })

      assert html =~ "Tunisia"
      assert html =~ "Syria"
      assert html =~ "5"
      assert html =~ "3"
    end

    test "renders nationalities with bold text when use_bold is true" do
      nationalities = [%CaseNationality{country: "US", count: 5}]

      html =
        render_component(&ExtendedComponents.nationalities_summary/1, %{
          nationalities: nationalities,
          use_bold: true
        })

      assert html =~ ~s(font-bold\">\n      United States)
    end
  end

  describe "map/1" do
    test "renders map container when positions are provided" do
      positions = [%{lat: 51.5074, lng: -0.1278}]
      html = render_component(&ExtendedComponents.map/1, %{positions: positions})

      assert html =~ ~s(id="case-map")
      assert html =~ ~s(phx-hook="Leaflet")
      assert html =~ ~s(data-positions=)
    end

    test "does not render map container when positions are empty" do
      html = render_component(&ExtendedComponents.map/1, %{positions: []})
      refute html =~ ~s(id="case-map")
    end
  end

  describe "theme_toggle/1" do
    test "renders theme toggle button and menu" do
      html = render_component(&ExtendedComponents.theme_toggle/1, %{})

      assert html =~ ~s(id="theme-toggle")
      assert html =~ ~s(phx-hook="ThemeToggle")
      assert html =~ "Toggle theme"
      assert html =~ ~s(id="theme-menu")
      assert html =~ "Light"
      assert html =~ "Dark"
      assert html =~ "System"
    end
  end
end
