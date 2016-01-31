defmodule Ginjyo.Tag do
  use Ginjyo.Web, :model

  alias Ginjyo.TagArticle

  schema "tags" do
    field :name, :string
    field :slug, :string

    has_many :tag_articles, TagArticle
    has_many :articles, through: [:tag_articles, :articles]

    timestamps
  end

  @required_fields ~w(name slug)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:slug, ~r/\A\w+\z/i)
    |> unique_constraint(:slug)
  end
end
