defmodule HospitalReadmissionServer.HospitalContactController do
  use HospitalReadmissionServer.Web, :controller

  alias HospitalReadmissionServer.HospitalContact

  plug :scrub_params, "hospital_contact" when action in [:create, :update]

  def index(conn, _params) do
    hospital_contacts = Repo.all(HospitalContact)
    render(conn, "index.html", hospital_contacts: hospital_contacts)
  end

  def new(conn, _params) do
    changeset = HospitalContact.changeset(%HospitalContact{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hospital_contact" => hospital_contact_params}) do
    changeset = HospitalContact.changeset(%HospitalContact{}, hospital_contact_params)

    case Repo.insert(changeset) do
      {:ok, _hospital_contact} ->
        conn
        |> put_flash(:info, "Hospital contact created successfully.")
        |> redirect(to: hospital_contact_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    hospital_contact = Repo.get!(HospitalContact, id)
    render(conn, "show.html", hospital_contact: hospital_contact)
  end

  def edit(conn, %{"id" => id}) do
    hospital_contact = Repo.get!(HospitalContact, id)
    changeset = HospitalContact.changeset(hospital_contact)
    render(conn, "edit.html", hospital_contact: hospital_contact, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hospital_contact" => hospital_contact_params}) do
    hospital_contact = Repo.get!(HospitalContact, id)
    changeset = HospitalContact.changeset(hospital_contact, hospital_contact_params)

    case Repo.update(changeset) do
      {:ok, hospital_contact} ->
        conn
        |> put_flash(:info, "Hospital contact updated successfully.")
        |> redirect(to: hospital_contact_path(conn, :show, hospital_contact))
      {:error, changeset} ->
        render(conn, "edit.html", hospital_contact: hospital_contact, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hospital_contact = Repo.get!(HospitalContact, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(hospital_contact)

    conn
    |> put_flash(:info, "Hospital contact deleted successfully.")
    |> redirect(to: hospital_contact_path(conn, :index))
  end
end
