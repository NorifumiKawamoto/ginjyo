# Ginjyo

[![Circle CI](https://circleci.com/gh/NorifumiKawamoto/ginjyo/tree/master.svg?style=svg)](https://circleci.com/gh/NorifumiKawamoto/ginjyo/tree/master)

To start your app:

Development:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start endpoint with `mix server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Deployment:

  * change prod.exs http: PORT if you want to use system_env  http:[port: {:system, "PORT"}],
  * $ MIX_ENV=prod mix phoenix.digest
  * $ MIX_ENV=prod mix release
  * rel/ginjyo/bin/ginjyo created!!
  * rel/ginjyo/bin/ginjyo start is server start command!
