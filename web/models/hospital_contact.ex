defmodule HospitalReadmissionServer.HospitalContact do
  use HospitalReadmissionServer.Web, :model

  schema "hospital_contacts" do
    field :provider_number, :integer
    field :hospital_name, :string
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :integer
    field :county_name, :string
    field :phone_number, :string
    field :hospital_type, :string
    field :hospital_ownership, :string
    field :emergency_services, :string
    field :location, :string

    timestamps
  end

  @required_fields ~w(provider_number hospital_name address city state zip county_name phone_number hospital_type hospital_ownership emergency_services location)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
