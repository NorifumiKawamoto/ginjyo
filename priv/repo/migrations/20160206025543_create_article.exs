defmodule Ginjyo.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :body, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:articles, [:user_id])
    create unique_index(:articles, [:title])

  end
end
