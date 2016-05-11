defmodule HospitalReadmissionServer.Repo.Migrations.CopyHospitalCsv do
  use Ecto.Migration

  def up do
    abs_path = Path.absname('/usr/share/Reformatted_Provider_Data.csv')
    IO.puts(abs_path)

    # Remove not null restriction on inserted_at and updated_at
    execute """
      ALTER TABLE hospital_contacts
      ALTER COLUMN inserted_at
      DROP NOT NULL,
      ALTER COLUMN updated_at
      DROP NOT NULL;
    """

    execute """
      COPY hospital_contacts(
        provider_number,
        hospital_name,
        address,
        city,
        state,
        ZIP,
        county_name,
        phone_number,
        hospital_type,
        hospital_ownership,
        emergency_services,
        location
      )
      FROM '#{abs_path}'
      WITH CSV HEADER;
    """

    # Set integers with value of -1 to NULL
    execute """
      UPDATE hospital_contacts
        SET ZIP = NULL
        WHERE ZIP = -1;
    """
    execute """
      UPDATE hospital_contacts
        SET provider_number = NULL
        WHERE provider_number = -1;
    """
    execute """
      UPDATE hospital_contacts
        SET phone_number = NULL
        WHERE phone_number = -1;
    """

    # elixir writes timestamps without timezone  = postgres.localtimestamp
    execute """
      UPDATE hospital_contacts
        SET inserted_at = localtimestamp,
        updated_at = localtimestamp
      WHERE
        inserted_at IS NULL
        OR updated_at IS NULL;
    """

    # Readd not null restriction on inserted_at and updated_at
    execute """
      ALTER TABLE hospital_contacts
      ALTER COLUMN inserted_at
      SET NOT NULL,
      ALTER COLUMN updated_at
      SET NOT NULL;
    """
  end

  def down do

  end
end

