defmodule Ginjyo.ArticleTest do
  use Ginjyo.ModelCase

  alias Ginjyo.Article

  @valid_attrs %{
    body: "some content",
    title: "some content",
    status: Article.get_status(:public),
    thumbnail_path: "/image/logo.png",
    tag_ids: [1]
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end
end
