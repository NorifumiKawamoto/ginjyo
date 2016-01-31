defmodule Ginjyo.TagTest do
  use Ginjyo.ModelCase

  alias Ginjyo.Tag

  @valid_attrs %{name: "tagname", slug: "tagslug"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end

end
