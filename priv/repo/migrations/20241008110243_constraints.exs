defmodule CaseManager.Repo.Migrations.Constraints do
  use Ecto.Migration

  def change do
    # Status constraint
    create constraint("cases", :status_constraint,
             check: "status IN ('open', 'ready_for_documentation', 'closed')"
           )

    # SAR region constraint
    create constraint("cases", :sar_region_constraint,
             check: "sar_region IN ('unknown', 'sar1', 'sar2', 'sar3')"
           )

    # Boat type constraint
    create constraint("cases", :boat_type_constraint,
             check:
               "boat_type IN ('unknown', 'rubber', 'wood', 'iron', 'fiberglass', 'fishing_vessel', 'other', 'sailing')"
           )

    # Boat color constraint
    create constraint("cases", :boat_color_constraint,
             check:
               "boat_color IN ('unknown', 'black', 'blue', 'brown', 'gray', 'green', 'other', 'red', 'white', 'yellow')"
           )

    # Boat engine failure constraint
    create constraint("cases", :boat_engine_failure_constraint,
             check: "boat_engine_failure IN ('unknown', 'yes', 'no')"
           )

    # Outcome constraint
    create constraint("cases", :outcome_constraint,
             check:
               "outcome IN ('unknown', 'interception_libya', 'interception_tn', 'ngo_rescue', 'afm_rescue', 'hcg_rescue', 'italy_rescue', 'merv_interception', 'merv_rescue', 'returned', 'arrived', 'autonomous', 'empty_boat', 'shipwreck')"
           )
  end
end
