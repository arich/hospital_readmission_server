defmodule HospitalReadmissionServer.HospitalTest do
  use HospitalReadmissionServer.ModelCase

  alias HospitalReadmissionServer.Hospital

  @valid_attrs %{end_date: "2010-04-17 14:00:00", excess_readmission_ratio: "120.5", expected_readmission_rate: "120.5", footnote: "some content", measure_name: "some content", name: "some content", number_of_discharges: 42, number_of_readmissions: 42, predicted_readmission_ratio: "120.5", provider_number: 42, start_date: "2010-04-17 14:00:00", state: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Hospital.changeset(%Hospital{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Hospital.changeset(%Hospital{}, @invalid_attrs)
    refute changeset.valid?
  end
end
