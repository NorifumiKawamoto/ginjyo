defmodule Ginjyo.Repo.Migrations.CreateTagArticle do
  use Ecto.Migration

  def change do
    create table(:tag_articles) do
      add :tag_id, references(:tags, on_delete: :nothing)
      add :article_id, references(:articles, on_delete: :nothing)

      timestamps
    end
    create index(:tag_articles, [:tag_id])
    create index(:tag_articles, [:article_id])

  end
end
