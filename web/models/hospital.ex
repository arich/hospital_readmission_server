defmodule HospitalReadmissionServer.Hospital do
  use HospitalReadmissionServer.Web, :model

  schema "hospitals" do
    field :name, :string
    field :provider_number, :integer
    field :state, :string
    field :measure_name, :string
    field :number_of_discharges, :integer
    field :footnote, :string
    field :excess_readmission_ratio, :float
    field :predicted_readmission_ratio, :float
    field :expected_readmission_rate, :float
    field :number_of_readmissions, :integer
    field :start_date, Ecto.DateTime
    field :end_date, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(provider_number state measure_name number_of_discharges footnote excess_readmission_ratio predicted_readmission_ratio expected_readmission_rate number_of_readmissions start_date end_date)

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
