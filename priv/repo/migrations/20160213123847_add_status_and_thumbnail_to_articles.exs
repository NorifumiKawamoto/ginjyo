defmodule Ginjyo.Repo.Migrations.AddStatusAndThumbnailToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :status, :integer
      add :thumbnail_path, :string
    end
  end
end
