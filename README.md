# Civil Case Manager & Logger
Receives incoming information (currently IMAP Idle, and Slack, (VOIP, SMS planned)) and provides a 
user interface to assign them to various cases. 

# Next Steps
* Sketch Side by side view
  
# TODO
* Prettify case selection a little
* Also, should maybe id be binary id and equal identifier??

# Minor
* New cases are streamed unfiltered
* Revisit automatic case creation

# Nice to have
* Markdown Editor: https://www.wysimark.com/docs/js

# Later
* https://fly.io/phoenix-files/liveview-multi-select/
* Open issue report: Documentation of corecomponent lacking.
* https://dev.to/seojeek/phoenix-deploys-with-elixir-1-9-with-systemd-no-docker-1od0

## Maybe
* DB: many_to_many :groups
* Make the modules export their "type" (eg. "imap")
* Make manual (boolean) a type.

## Ideas
if more advanced Access Control is needed:
https://github.com/woylie/let_me


# To use

To start the server:

  * Copy EXAMPLEworkers.exs to workers.exs and configure as needed.
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

