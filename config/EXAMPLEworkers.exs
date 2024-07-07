import Config
alias Events.Datasources

config :events, :worker_configs, [
  {
    Datasources.IMAPSupervisor,
    [
      name: :BOBS_ACCOUNT,
      server: "imap.example.net",
      username: "bob@example",
      password: "password"
    ]
  },
  {
    Datasources.SlackSupervisor,
    [
      name: :SLACK_ORG_NAME,
      app_token: "8975892304590234758902345",
      bot_token: "sdfjlgh089943w50734250235",
      channels: [
        types: ["public_channel", "im", "private_channel"]
      ]
    ]
  }
]
