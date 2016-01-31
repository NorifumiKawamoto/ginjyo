defmodule Ginjyo.Asset do
  use Ginjyo.Web, :model

  schema "assets" do
    field :content_type, :string
    field :filename, :string
    field :filesize, :integer

    timestamps
  end

  @required_fields ~w(content_type filename filesize)
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
