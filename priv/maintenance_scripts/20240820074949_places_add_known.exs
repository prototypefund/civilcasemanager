defmodule CaseManager.Repo.Migrations.PlacesAddKnown do
  use Ecto.Migration
  alias CaseManager.Places.Place

  def change do
    # Departure places

    repo().insert(%Place{
      name: "Skikda",
      country: "Algeria",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: nil
    })

    repo().insert(%Place{
      name: "Abu Kammash",
      country: "Libya",
      lat: 33.07963,
      lon: 11.7357805,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "al-Maya",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :both,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Chebba",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Djerba",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Gabes",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Kerkennah",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Madhia",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Monastir",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Sabratah",
      country: "Libya",
      lat: 32.815111,
      lon: 12.447443,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Sfax",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Sousse",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Tripoli",
      country: "Libya",
      lat: 32.8973425,
      lon: 13.168988,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Tunisia",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Zarsis",
      country: "Tunisia",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Zawiyah",
      country: "Libya",
      lat: 32.792995,
      lon: 12.726246,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "Zuwarah",
      country: "Libya",
      lat: 32.9376009,
      lon: 12.088314,
      type: :departure,
      sar_zone: :sar1
    })

    repo().insert(%Place{
      name: "al-Khums",
      country: "Libya",
      lat: 32.6566395,
      lon: 14.271958,
      type: :departure,
      sar_zone: :sar2
    })

    repo().insert(%Place{
      name: "Alaluas",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar2
    })

    repo().insert(%Place{
      name: "Garabulli",
      country: "Libya",
      lat: 32.795056,
      lon: 13.71428,
      type: :departure,
      sar_zone: :sar2
    })

    repo().insert(%Place{
      name: "Misratah",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar2
    })

    repo().insert(%Place{
      name: "Tajura",
      country: "Libya",
      lat: 32.8970637,
      lon: 13.38442,
      type: :departure,
      sar_zone: :sar2
    })

    repo().insert(%Place{
      name: "Zliten",
      country: "Libya",
      lat: 32.490281,
      lon: 14.6257384,
      type: :departure,
      sar_zone: :sar2
    })

    repo().insert(%Place{
      name: "Ajdabiya",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Benghazi",
      country: "Libya",
      lat: 32.031383,
      lon: 20.008286,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Bodrum",
      country: "Turkey",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Bomba",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Darna",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Izmir",
      country: "Turkey",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Minieh",
      country: "Lebanon",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Ras Lanuf",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Sirte",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Tobruk",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :departure,
      sar_zone: :sar3
    })

    repo().insert(%Place{
      name: "Tripolis",
      country: "Libya",
      lat: nil,
      lon: nil,
      type: :both,
      sar_zone: :sar3
    })

    # Disembarkation places
    repo().insert(%Place{
      name: "Augusta",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Bari",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Brindisi",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Catania",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Civitavecchia",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Crotone",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Genova",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Gioia Tauro",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "La Spezia",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Lampedusa",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Livorno",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Locride",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Marina di Carra",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Messina",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Naples",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Porto Empedocle",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Portopalo",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Pozzallo",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Ragusa",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Ravenna",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Reggio Calabria",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Roccella Ionica",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Salento",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Salerno",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Siracusa",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Taranto",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Trapani",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Vibo Valentina",
      country: "Italy",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Malta",
      country: "Malta",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Palaiochora",
      country: "Greece",
      lat: nil,
      lon: nil,
      type: :arrival
    })

    repo().insert(%Place{
      name: "Port Said",
      country: "Egypt",
      lat: nil,
      lon: nil,
      type: :arrival
    })
  end
end
