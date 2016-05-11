defmodule HospitalReadmissionServer.StateTest do
  use HospitalReadmissionServer.ModelCase

  alias HospitalReadmissionServer.State

  @valid_attrs %{abbrev: "some content", name: "some content", population: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = State.changeset(%State{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = State.changeset(%State{}, @invalid_attrs)
    refute changeset.valid?
  end
end
