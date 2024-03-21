import Config

config :events, :worker_configs,
  [
    {
      Events.IMAPFetcher,
      [
        server: "imap.example.net",
        username: "bob@example",
        password: "password",
        name: :bobs_account
      ]
    }
  ]
