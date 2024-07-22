# Civil Case Manager & Logger
A realtime case managment and event processing platform for the humantarian sector.
Comes with a number of configurable worker services that can process incoming information and match it automatically to cases. 
Current workers: IMAP and Slack. Workers can be written with small amounts of code: The IMAP workers weighs around 100LOC, the Slack worker 200LOC.

## Requirements
- Erlang/OTP 24 or later
- Elixir 1.14 or later
- PostgreSQL 13 or later (older versions should be fine but untested)

This project is built using the Phoenix Framework, which provides a powerful and flexible web development framework. It's executed on the Erlang VM, which was created to create scalable and fault-tolerant realtime systems.

## Running 
### Docker
Using Docker: The easiest way to run the Civil Case Manager is to use Docker. This will ensure that all the necessary dependencies are installed and configured correctly.
To build the Docker container, make sure you have Docker installed on your system:

1. `cd` into the project root directory containing the Dockerfile.
2. Copy the environment file and modify it as needed:

   `cp .env.example .env`

3. Build the Docker image:

   `docker build -t civilcasemanager .`

4. Once the build is complete, you can run the container using Docker Compose:

   `docker-compose up`

   This command will start both the Civil Case Manager and a PostgreSQL database.

5. The default configuration will have no workers defined. To setup workers to listen to incoming events, create a `workers.exs` configuration file, and modify the docker-compose file to link it into the container:

  ```
   volumes:
     - /path/to/workers.exs:/app/config/workers.exs
   ```


   Refer to config/workers.exs.EXAMPLE for an example of a workers.exs file.

The Civil Case Manager & Logger should now be running in a Docker container along with a PostgreSQL database, and accessible on port 4000.


## Developing
### Setup
* Install Phoenix, Elixir and Postgres. The Phoenix docs have a [good overview on this](https://hexdocs.pm/phoenix/installation.html).

* Run `mix setup` to install and setup dependencies
* Start the server with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


### Adding new workers
To add new workers to the Civil Case Manager & Logger, you can follow these steps:

1. Create a new module for your worker in the `lib/datasources` directory.
2. Add both a supervisor and an a worker process.
3. The supervisor will be responsible to spawning on or more worker processes.
4. The worker processes do the actual job of conencting to some external service and receiving data
5. Once you have received data, pass it onto the core application using `CaseManager.FetchEvent` structs:

```
    event = %CaseManager.FetchEvent{
      type: IMAPSupervisor.event_type(),
      body: extract_body(message.body),
      from: extract_email_address(message.from),
      title: message.subject,
      received_at: DateTime.utc_now(),
      metadata: Enum.map_join(message.headers, "\n", &Enum.join(&1, ": "))
    }

    manager_pid = Process.whereis(:fetch_manager)
    GenServer.cast(manager_pid, {:new_event, event})
```


Refer to IMAP and Slackworkers for an existing implementation.

## Contributing
Contributions are welcome and encouraged. To contribute, please follow these steps:

  * Fork the repository
  * Create a new branch for your changes
  * Run `mix test` and `mix format`over your changes
  * Open a merge request here



