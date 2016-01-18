defmodule HospitalReadmissionServer.HospitalControllerTest do
  use HospitalReadmissionServer.ConnCase

  alias HospitalReadmissionServer.Hospital
  @valid_attrs %{end_date: "2010-04-17 14:00:00", excess_readmission_ratio: "120.5", expected_readmission_rate: "120.5", footnote: "some content", measure_name: "some content", name: "some content", number_of_discharges: 42, number_of_readmissions: 42, predicted_readmission_ratio: "120.5", provider_number: 42, start_date: "2010-04-17 14:00:00", state: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, hospital_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing hospitals"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, hospital_path(conn, :new)
    assert html_response(conn, 200) =~ "New hospital"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, hospital_path(conn, :create), hospital: @valid_attrs
    assert redirected_to(conn) == hospital_path(conn, :index)
    assert Repo.get_by(Hospital, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, hospital_path(conn, :create), hospital: @invalid_attrs
    assert html_response(conn, 200) =~ "New hospital"
  end

  test "shows chosen resource", %{conn: conn} do
    hospital = Repo.insert! %Hospital{}
    conn = get conn, hospital_path(conn, :show, hospital)
    assert html_response(conn, 200) =~ "Show hospital"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, hospital_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    hospital = Repo.insert! %Hospital{}
    conn = get conn, hospital_path(conn, :edit, hospital)
    assert html_response(conn, 200) =~ "Edit hospital"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    hospital = Repo.insert! %Hospital{}
    conn = put conn, hospital_path(conn, :update, hospital), hospital: @valid_attrs
    assert redirected_to(conn) == hospital_path(conn, :show, hospital)
    assert Repo.get_by(Hospital, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    hospital = Repo.insert! %Hospital{}
    conn = put conn, hospital_path(conn, :update, hospital), hospital: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit hospital"
  end

  test "deletes chosen resource", %{conn: conn} do
    hospital = Repo.insert! %Hospital{}
    conn = delete conn, hospital_path(conn, :delete, hospital)
    assert redirected_to(conn) == hospital_path(conn, :index)
    refute Repo.get(Hospital, hospital.id)
  end
end
