defmodule Ginjyo.Repo.Migrations.CreateAsset do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :content_type, :string
      add :filename, :string
      add :filesize, :integer

      timestamps
    end

  end
end
