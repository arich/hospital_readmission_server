defmodule HospitalReadmissionServer.Repo.Migrations.CreateContactTable do
  use Ecto.Migration

  def change do
    create table(:hospital_contacts) do
      add :provider_number, :integer
      add :hospital_name, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :ZIP, :integer
      add :county_name, :string
      add :phone_number, :string
      add :hospital_type, :string
      add :hospital_ownership, :string
      add :emergency_services, :string
      add :location, :string

      timestamps
    end
  end
end

