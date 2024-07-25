defmodule CaseManager.Places do
  def valid_departure_places,
    do: %{
      sar1: [
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
      sar2: [
        "al-Khums",
        "Alaluas",
        "Garabulli",
        "Misratah",
        "Tajura",
        "Zliten"
      ],
      sar3: [
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
    }

  def valid_disembarkation_places,
    do: %{
      italy: [
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
      malta: ["Malta"],
      libya: [
        "Al-Maya",
        "Tripoli"
      ],
      greece: ["Palaiochora"],
      egypt: ["Port Said"]
    }

  def valid_departure_regions,
    do: [
      "Libya",
      "Tunisia",
      "Lebanon",
      "Turkey",
      "Syria"
    ]
end
