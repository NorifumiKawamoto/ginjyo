defmodule Ginjyo.ArticleControllerTest do
  use Ginjyo.ConnCase

  alias Ginjyo.Factory
  alias Ginjyo.Article

  @valid_attrs %{
    body: "some content",
    title: "some content",
    status: Article.get_status(:public),
    thumbnail_path: "/image/logo.png",
    tag_ids: [1]
  }
  @invalid_attrs %{}

  setup do
    conn = conn()
    user = Factory.create(:user)
    article = Factory.create(:article)
    tag = Factory.create(:tag)
    conn = post conn,
      session_path(conn, :create),
      session: %{email: user.email, password: user.password}

    {:ok, conn: conn, article: article, tag: tag}
  end

  test "GET /articles" do
    user = Factory.create(:user)
    article = Factory.create(:article, %{user: user})
    conn = get conn, article_path(conn, :index)
    assert html_response(conn, 200) =~ article.title
  end

  test "GET /articles pagenation" do
    user = Factory.create(:user)
    multi_articles(10, user)
    article = Factory.create(:article, %{user: user})
    conn = get conn, article_path(conn, :index),  page: 2
    assert html_response(conn, 200) =~ article.title
  end

  test "GET /tags/:id" do
    tag  = Factory.create(:tag)
    article = Factory.create(:article)
    Factory.create(:tag_article, %{tag_id: tag.id, article_id: article.id})
    conn = get conn, article_path(conn, :tagshow, tag)
    assert html_response(conn, 200) =~ article.title
  end

  test "GET /tags/:id pagenation" do
    user = Factory.create(:user)
    tag  = Factory.create(:tag)
    multi_tag_articles(10, user, tag)
    article = Factory.create(:article, %{user: user})
    Factory.create(:tag_article, %{tag_id: tag.id, article_id: article.id})
    conn = get conn, article_path(conn, :tagshow, tag), page: 2
    assert html_response(conn, 200) =~ article.title
  end

  defp multi_tag_articles(n, user, tag) when n <= 1 do
    article = Factory.create(:article, %{user: user})
    Factory.create(:tag_article, %{tag_id: tag.id, article_id: article.id})
  end

  defp multi_tag_articles(n, user, tag) do
    article = Factory.create(:article, %{user: user})
    Factory.create(:tag_article, %{tag_id: tag.id, article_id: article.id})
    multi_tag_articles(n - 1, user, tag)
  end

  defp multi_articles(n, user) when n <= 1 do
    Factory.create(:article, %{user: user})
  end

  defp multi_articles(n, user) do
    Factory.create(:article, %{user: user})
    multi_articles(n - 1, user)
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
    session: %{email: user.email, password: user.password}
  end

  test "GET /articles/id" do
    Factory.create(:user)
    user = Factory.create(:user)
    article = Factory.create(:article, %{user: user})
    conn = get conn, article_path(conn, :show, article)
    assert html_response(conn, 200) =~ article.body
  end

  test "GET /articles/new no login" do
    conn = get conn, article_path(conn, :new)
    assert html_response(conn, 302)
  end

  test "GET /articles/new login" do
    user = Factory.create(:user)
    conn = login_user(conn, user)
    conn = get conn, article_path(conn, :new)
    assert html_response(conn, 200) =~ "New Article"
  end

  test "GET /articles/create " do
    user = Factory.create(:user)
    tag = Factory.create(:tag, %{id: 1})
    conn = login_user(conn, user)
    conn = post conn, article_path(conn, :create), article: @valid_attrs
    assert get_flash(conn, :info) == "Article created successfully."
  end

  test "GET /articles/edit no login" do
    article = Factory.create(:article)
    conn = get conn, article_path(conn, :edit, article)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "GET /articles/edit login" do
    user = Factory.create(:user)
    article = Factory.create(:article)
    conn = login_user(conn, user)
    conn = get conn, article_path(conn, :edit, article)
    assert html_response(conn, 200) =~ "Edit Article"
  end

  test "GET /articles/update ", %{conn: conn, article: article, tag: tag} do
    conn = put conn, article_path(conn, :update, article),
    article:  %{title: "some content", body: "somecontent", tag_ids: [tag.id]}
    assert redirected_to(conn) == article_path(conn, :show, article)
    assert Repo.get_by(Article,  %{title: "some content", body: "somecontent"})
  end

end
