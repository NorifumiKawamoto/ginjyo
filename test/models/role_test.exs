defmodule Ginjyo.RoleTest do
  use Ginjyo.ModelCase

  alias Ginjyo.Role

  @valid_attrs %{name: "some content", rank: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Role.changeset(%Role{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Role.changeset(%Role{}, @invalid_attrs)
    refute changeset.valid?
  end
end
