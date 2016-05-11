defmodule HospitalReadmissionServer.HospitalContactTest do
  use HospitalReadmissionServer.ModelCase

  alias HospitalReadmissionServer.HospitalContact

  @valid_attrs %{address: "some content", city: "some content", county_name: "some content", emergency_services: "some content", hospital_name: "some content", hospital_ownership: "some content", hospital_type: "some content", location: "some content", phone_number: "some content", provider_number: 42, state: "some content", zip: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = HospitalContact.changeset(%HospitalContact{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = HospitalContact.changeset(%HospitalContact{}, @invalid_attrs)
    refute changeset.valid?
  end
end
