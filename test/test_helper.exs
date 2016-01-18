ExUnit.start

Mix.Task.run "ecto.create", ~w(-r HospitalReadmissionServer.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r HospitalReadmissionServer.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(HospitalReadmissionServer.Repo)

