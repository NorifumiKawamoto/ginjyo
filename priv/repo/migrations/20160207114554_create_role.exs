defmodule Ginjyo.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :rank, :integer

      timestamps
    end

  end
end
