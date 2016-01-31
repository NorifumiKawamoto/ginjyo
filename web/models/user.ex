defmodule Ginjyo.User do
  use Ginjyo.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    belongs_to :role, Ginjyo.Role
    has_many :articles, Ginjyo.Article
    timestamps
  end

  @required_fields ~w(email password password_confirmation role_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_length(:password, max: 20)
    |> validate_confirmation(:password)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:crypted_password, Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end

end
