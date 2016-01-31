defmodule Ginjyo.TagArticleTest do
  use Ginjyo.ModelCase

  alias Ginjyo.TagArticle
  alias Ginjyo.Factory

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    Factory.create(:tag)
    tag = Factory.create(:tag)
    article = Factory.create(:article)
    changeset = TagArticle.changeset(
      %TagArticle{},
      %{tag_id: tag.id, article_id: article.id}
    )
    assert changeset.valid?
  end

  # test "changeset with invalid attributes" do
  #   changeset = TagArticle.changeset(%TagArticle{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
