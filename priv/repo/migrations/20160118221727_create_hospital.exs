defmodule HospitalReadmissionServer.Repo.Migrations.CreateHospital do
  use Ecto.Migration

  def change do
    create table(:hospitals) do
      add :name, :string
      add :provider_number, :integer
      add :state, :string
      add :measure_name, :string
      add :number_of_discharges, :integer
      add :footnote, :string
      add :excess_readmission_ratio, :float
      add :predicted_readmission_ratio, :float
      add :expected_readmission_rate, :float
      add :number_of_readmissions, :integer
      add :start_date, :date
      add :end_date, :date

      timestamps
    end

  end
end
