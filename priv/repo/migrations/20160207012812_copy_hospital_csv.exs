defmodule HospitalReadmissionServer.Repo.Migrations.CopyHospitalCsv do
  use Ecto.Migration

  def up do
    #abs_path = Path.absname('priv/repo/data_files/Hospital_Readmissions_Reduction_Program.csv')
    abs_path = Path.absname('/usr/share/Reformatted_Hospital_Data.csv')
    IO.puts(abs_path)

    # Remove not null restriction on inserted_at and updated_at
    execute """
      ALTER TABLE hospitals
      ALTER COLUMN inserted_at
      DROP NOT NULL,
      ALTER COLUMN updated_at
      DROP NOT NULL;
    """

    execute """
      COPY hospitals(
        name,
        provider_number,
        state,
        measure_name,
        number_of_discharges,
        footnote,
        excess_readmission_ratio,
        predicted_readmission_ratio,
        expected_readmission_rate,
        number_of_readmissions,
        start_date,
        end_date
      )
      FROM '#{abs_path}'
      WITH CSV HEADER;
    """

    # Set integers with value of -1 to NULL
    execute """
      UPDATE hospitals
        SET number_of_discharges = NULL
        WHERE number_of_discharges = -1;
    """
    execute """
      UPDATE hospitals
        SET provider_number = NULL
        WHERE provider_number = -1;
    """
    execute """
      UPDATE hospitals
        SET number_of_readmissions = NULL
        WHERE number_of_readmissions = -1;
    """

    # elixir writes timestamps without timezone  = postgres.localtimestamp
    execute """
      UPDATE hospitals
        SET inserted_at = localtimestamp,
        updated_at = localtimestamp
      WHERE
        inserted_at IS NULL
        OR updated_at IS NULL;
    """

    # Readd not null restriction on inserted_at and updated_at
    execute """
      ALTER TABLE hospitals
      ALTER COLUMN inserted_at
      SET NOT NULL,
      ALTER COLUMN updated_at
      SET NOT NULL;
    """
  end

  def down do

  end
end
