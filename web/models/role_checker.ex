defmodule Ginjyo.RoleChecker do
  alias Ginjyo.Repo
  alias Ginjyo.Role
  alias Ginjyo.User

  def is_admin?(user) do
    role = Repo.get(Role, user.role_id)
    role.rank >= 10
  end

end
