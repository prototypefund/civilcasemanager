# Civil Case Manager & Logger
Receives incoming information (currently IMAP Idle, VOIP, SMS planned) and provides a 
user interface to assign them to various cases. 

# TODO
* Double animation on reload
* Prettify case selection a little
* Modules into seperate Folder
* Schick machen und pitchen
* Add startpage

# LATER
* Check names in IMAP regarding parallel execution. 
* https://fly.io/phoenix-files/liveview-multi-select/
* Use prod for staging server
* Documentation of corecomponent lacking.
* https://dev.to/seojeek/phoenix-deploys-with-elixir-1-9-with-systemd-no-docker-1od0

## Maybe
* DB: many_to_many :groups
* Make the modules export their "type" (eg. "imap")
* Make manual (boolean) a type.

## Ideas
if more advanced Access Control is needed:
https://github.com/woylie/let_me


# Events

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
