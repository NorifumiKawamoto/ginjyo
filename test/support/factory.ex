defmodule Ginjyo.Factory do
  use ExMachina.Ecto, repo: Ginjyo.Repo

  alias Ginjyo.Role
  alias Ginjyo.User
  alias Ginjyo.Article
  alias Ginjyo.Tag
  alias Ginjyo.TagArticle
  alias Comeonin.Bcrypt

  def factory(:role) do
    %Role{
      name: sequence(:name, &"Test Role #{&1}"),
      rank: :rank,
    }
  end

  def factory(:user) do
    %User{
      email: sequence(:email, &"test#{&1}@test.com"),
      password: "test1234",
      password_confirmation: "test1234",
      crypted_password: Bcrypt.hashpwsalt("test1234"),
      role: build(:role, rank: 0),
    }
  end

  def factory(:article) do
    %Article{
      title: sequence(:title, &"title#{&1}"),
      body: sequence(:body, &"body#{&1}"),
      status: Article.get_status(:public),
      thumbnail_path: "/image/logo.png",
      user: build(:user),
    }
  end

  def factory(:tag) do
    %Tag{
      name: sequence(:name, &"name#{&1}"),
      slug: sequence(:slug, &"slug#{&1}"),
    }
  end

  def factory(:tag_article) do
    %TagArticle{
      tag_id: sequence(:tag_id, fn(n) -> n end),
      article_id: sequence(:article_id, fn(n) -> n end),
    }
  end

end
