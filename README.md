# Civil Case Manager & Logger
Receives incoming information (currently IMAP Idle, and Slack, (VOIP, SMS planned)) and provides a 
user interface to assign them to various cases. 

# Next Steps
- [ ] Filter changed events in case view
- [ ] Parse Thuraya 
- [ ] Flop bugs
- [x] Finish yugo PR
- [ ] Add possibility only specify POB total
  
# TODO
- [ ] Prettify case selection a little

# Minor
- [ ] New cases are streamed unfiltered
- [ ] When cases are created trough casts, there is no event emitted.
- [ ] Add dropdowns (in embedded)
- [ ] Turn types into :atoms or ints
- [x] Remove html-helpers
- [x] Rename "imap" to "email"

# v1.0
* Quick Compose: Titel, Timestamp
* Markdown editor: Prosemirror?
* Thuraya
* Positions?
* Attachments: Native support avaliable.


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

