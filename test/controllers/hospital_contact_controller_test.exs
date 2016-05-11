defmodule HospitalReadmissionServer.HospitalContactControllerTest do
  use HospitalReadmissionServer.ConnCase

  alias HospitalReadmissionServer.HospitalContact
  @valid_attrs %{address: "some content", city: "some content", county_name: "some content", emergency_services: "some content", hospital_name: "some content", hospital_ownership: "some content", hospital_type: "some content", location: "some content", phone_number: "some content", provider_number: 42, state: "some content", zip: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, hospital_contact_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing hospital contacts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, hospital_contact_path(conn, :new)
    assert html_response(conn, 200) =~ "New hospital contact"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, hospital_contact_path(conn, :create), hospital_contact: @valid_attrs
    assert redirected_to(conn) == hospital_contact_path(conn, :index)
    assert Repo.get_by(HospitalContact, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, hospital_contact_path(conn, :create), hospital_contact: @invalid_attrs
    assert html_response(conn, 200) =~ "New hospital contact"
  end

  test "shows chosen resource", %{conn: conn} do
    hospital_contact = Repo.insert! %HospitalContact{}
    conn = get conn, hospital_contact_path(conn, :show, hospital_contact)
    assert html_response(conn, 200) =~ "Show hospital contact"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, hospital_contact_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    hospital_contact = Repo.insert! %HospitalContact{}
    conn = get conn, hospital_contact_path(conn, :edit, hospital_contact)
    assert html_response(conn, 200) =~ "Edit hospital contact"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    hospital_contact = Repo.insert! %HospitalContact{}
    conn = put conn, hospital_contact_path(conn, :update, hospital_contact), hospital_contact: @valid_attrs
    assert redirected_to(conn) == hospital_contact_path(conn, :show, hospital_contact)
    assert Repo.get_by(HospitalContact, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    hospital_contact = Repo.insert! %HospitalContact{}
    conn = put conn, hospital_contact_path(conn, :update, hospital_contact), hospital_contact: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit hospital contact"
  end

  test "deletes chosen resource", %{conn: conn} do
    hospital_contact = Repo.insert! %HospitalContact{}
    conn = delete conn, hospital_contact_path(conn, :delete, hospital_contact)
    assert redirected_to(conn) == hospital_contact_path(conn, :index)
    refute Repo.get(HospitalContact, hospital_contact.id)
  end
end
