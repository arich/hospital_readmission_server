defmodule HospitalReadmissionServer.Repo.Migrations.CreateStatesTable do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :name, :string
      add :abbrev, :string
      add :population, :integer
      timestamps
    end
  end
end
