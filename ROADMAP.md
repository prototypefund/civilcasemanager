# v2.0
- Quick Compose: Titel, Timestamp
- [ ] New cases are streamed unfiltered
- [ ] When cases are created trough casts, there is no event emitted.
- [ ] Add dropdowns (in embedded)
* Markdown editor: Prosemirror?
* Prettify case  selection (in events) a little
* Thuraya?
* Attachments: Native support avaliable.

# v3.0
* Filter changed events in case view
* Maps: https://medium.com/@thomas.poumarede/from-scratch-to-map-my-mapbox-integration-experience-with-phoenix-liveview-using-elixir-aa84fca2b979

# Platform issues to report
- [ ] get_options_for_cases breaks with default value coming from DB
- [ ] cast_assoc doesnt accept [%Case{}] but only [%{}, while put_assoc does
- [x] Params of Changeset are not logged.

# Later
* Also, should we maybe turn identifier into primary_id?

## Maybe
* DB: many_to_many :groups

## Ideas
if more advanced Access Control is needed:
Permit


