ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Ginjyo.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Ginjyo.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Ginjyo.Repo)
