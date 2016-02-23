defmodule Ginjyo.Repo.Migrations.AddPublishedAtToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :published_at, :datetime
    end
  end
end
