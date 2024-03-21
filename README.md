# Civil Case Manager & Logger
Receives incoming information (currently IMAP Idle, VOIP, SMS planned) and provides a 
user interface to assign them to various cases. 

# TODO
* Double animation on reload
* Create staging deploy on vps
* Modules into seperate Folder
* Schick machen und pitchen
* Documentation of corecomponent slacking.

# LATER
* Check names in IMAP regarding parallel execution. 

## Maybe
* DB: Add belongs_to :type, many_to_many :groups
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
