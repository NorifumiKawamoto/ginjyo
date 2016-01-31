defmodule Ginjyo.AssetTest do
  use Ginjyo.ModelCase

  alias Ginjyo.Asset

  @valid_attrs %{
    content_type: "some content",
    filename: "some content",
    filesize: 42
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Asset.changeset(%Asset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Asset.changeset(%Asset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
