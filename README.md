# Civil Case Manager & Logger
Receives incoming information (currently IMAP Idle, VOIP, SMS planned) and provides a 
user interface to assign them to various cases. 

# TODO
* Import UI
* Create staging deploy on vps
* Modules into seperate Folder
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



mix phx.gen.live Cases Case cases identifier:string title:string description:string created_at:utc_datetime updated_at:utc_datetime deleted_at:utc_datetime opened_at:utc_datetime closed_at:utc_datetime archived_at:utc_datetime is_archived:boolean status:string status_note:string
