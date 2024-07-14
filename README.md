# Civil Case Manager & Logger
Receives incoming information (currently IMAP Idle, and Slack, (VOIP, SMS planned)) and provides a 
user interface to assign them to various cases. 


# v1.0
- [x] Add Flash :warning
- [x] Fix next import cases navigation
- [x] Fix dropdown validation
- [x] Replace common outcome strings
- [ ] Style validation errors
- [ ] Style fill hints
- [ ] Add delete button to validation form
- [x] Take validation form out of popup
- [x] Delete queue red, and right and padding
- [ ] Embedded positions in form

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
* https://dev.to/seojeek/phoenix-deploys-with-elixir-1-9-with-systemd-no-docker-1od0

## Maybe
* DB: many_to_many :groups

## Ideas
if more advanced Access Control is needed:
https://github.com/woylie/let_me


# To use
To start the server:

  * Copy EXAMPLEworkers.exs to workers.exs and configure as needed.
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

