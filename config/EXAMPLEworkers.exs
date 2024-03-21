import Config
alias Events.Datasources

config :events, :worker_configs,
  [
    {
      IMAPFetcher,
      [
        server: "imap.example.net",
        username: "bob@example",
        password: "password",
        name: :bobs_account
      ]
    }
  ]
