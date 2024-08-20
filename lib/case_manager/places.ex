defmodule CaseManager.Places do
  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.Places.Place

  @doc """
  Returns the list of places.

  ## Examples

      iex> list_places()
      [%Place{}, ...]

  """
  def list_places do
    Repo.all(Place)
  end

  @doc """
  Gets a single place.

  Raises `Ecto.NoResultsError` if the Place does not exist.

  ## Examples

      iex> get_place!("Some Place")
      %Place{}

      iex> get_place!("Non-existent Place")
      ** (Ecto.NoResultsError)

  """
  def get_place!(name), do: Repo.get_by!(Place, name: name)

  @doc """
  Creates a place.

  ## Examples

      iex> create_place(%{field: value})
      {:ok, %Place{}}

      iex> create_place(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_place(attrs \\ %{}) do
    %Place{}
    |> Place.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a place.

  ## Examples

      iex> update_place(place, %{field: new_value})
      {:ok, %Place{}}

      iex> update_place(place, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_place(%Place{} = place, attrs) do
    place
    |> Place.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a place.

  ## Examples

      iex> delete_place(place)
      {:ok, %Place{}}

      iex> delete_place(place)
      {:error, %Ecto.Changeset{}}

  """
  def delete_place(%Place{} = place) do
    Repo.delete(place)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking place changes.

  ## Examples

      iex> change_place(place)
      %Ecto.Changeset{data: %Place{}}

  """
  def change_place(%Place{} = place, attrs \\ %{}) do
    Place.changeset(place, attrs)
  end

  @doc """
  Returns a list of place options for select inputs based on the given type,
  grouped by country.

  ## Examples

      iex> get_options_for_select(:arrival)
      [
        Italy: ["Palermo", ...],
        Malta: ["Malta", ...],
        ...
      ]

  """
  def get_places_for_select(type) do
    list_places()
    |> Enum.filter(&(&1.type in [type, :both]))
    |> Enum.group_by(& &1.country, & &1.name)
    |> Enum.map(fn {country, cities} -> {String.to_atom(country), cities} end)
  end

  def valid_departure_places,
    do: [
      unknown: [:unknown],
      SAR1: [
        "Abu Kammash",
        "al-Maya",
        "Chebba",
        "Djerba",
        "Gabes",
        "Kerkennah",
        "Madhia",
        "Monastir",
        "Sabratah",
        "Sfax",
        "Sousse",
        "Tripoli",
        "Tunisia",
        "Zarsis",
        "Zawiyah",
        "Zuwarah"
      ],
      SAR2: [
        "al-Khums",
        "Alaluas",
        "Garabulli",
        "Misratah",
        "Tajura",
        "Zliten"
      ],
      SAR3: [
        "Ajdabiya",
        "Benghazi",
        "Bodrum",
        "Bomba",
        "Darna",
        "Izmir, Turkey",
        "Minieh, Lebanon",
        "Ras Lanuf",
        "Sirte",
        "Tobruk",
        "Tripolis"
      ]
    ]

  def valid_disembarkation_places,
    do: [
      unknown: [:unknown],
      Italy: [
        "Augusta",
        "Bari",
        "Brindisi",
        "Catania",
        "Civitavecchia",
        "Crotone",
        "Genova",
        "Gioia Tauro",
        "La Spezia",
        "Lampedusa",
        "Livorno",
        "Locride",
        "Marina di Carra",
        "Messina",
        "Naples",
        "Porto Empedocle",
        "Portopalo",
        "Pozzallo",
        "Ragusa",
        "Ravenna",
        "Reggio Calabria",
        "Roccella Ionica",
        "Salento",
        "Salerno",
        "Siracusa",
        "Taranto",
        "Trapani",
        "Vibo Valentina"
      ],
      Malta: ["Malta"],
      Libya: [
        "Al-Maya",
        "Tripoli"
      ],
      Greece: ["Palaiochora"],
      Egypt: ["Port Said"]
    ]

  def valid_departure_regions,
    do: [
      :unknown,
      "Libya",
      "Tunisia",
      "Lebanon",
      "Turkey",
      "Syria"
    ]
end
