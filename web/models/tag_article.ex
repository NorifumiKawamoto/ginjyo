defmodule Ginjyo.TagArticle do
  use Ginjyo.Web, :model

  schema "tag_articles" do
    belongs_to :tag, Ginjyo.Tag
    belongs_to :article, Ginjyo.Article

    timestamps
  end

  @required_fields ~w(tag_id article_id)
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
