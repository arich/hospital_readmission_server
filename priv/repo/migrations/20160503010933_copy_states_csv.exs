defmodule HospitalReadmissionServer.Repo.Migrations.CopyStatesCsv do
  use Ecto.Migration

  def change do
    abs_path = Path.absname('/usr/share/Reformatted_Census_Data.csv')
    IO.puts(abs_path)

    # Remove not null restriction on inserted_at and updated_at
    execute """
      ALTER TABLE states
      ALTER COLUMN inserted_at
      DROP NOT NULL,
      ALTER COLUMN updated_at
      DROP NOT NULL;
    """

    execute """
      COPY states(
        name,
        population,
        abbrev
      )
      FROM '#{abs_path}'
      WITH CSV HEADER;
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
end
