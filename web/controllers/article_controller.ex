defmodule Ginjyo.ArticleController do
  use Ginjyo.Web, :controller
  alias Ginjyo.Article
  alias Ginjyo.TagArticle
  alias Ginjyo.Tag
  alias Ginjyo.Session

  plug Ginjyo.Plugs.AllowUser when action in [:new, :create, :edit]
  plug :scrub_params, "article" when action in [:create, :update]
  plug :check_status when action in [:show]

  def index(conn, %{"page" => page}) do
    user = Session.current_user(conn)
    all_tags = Repo.all(Tag)
    pages = Article
    |> Article.show_order()
    |> Article.show_limit(user)
    |> Repo.paginate(page: page)
    render conn, "index.html", pages: pages, all_tags: all_tags
  end

  def index(conn, _) do
    user = Session.current_user(conn)
    all_tags = Repo.all(Tag)
    pages = Article
    |> Article.show_order()
    |> Article.show_limit(user)
    |> Repo.paginate()
    render conn, "index.html", pages: pages, all_tags: all_tags
  end

  def show(conn, %{"id" => id}) do
    all_tags = Repo.all(Tag)
    article = Repo.get(Article, id)
    |> Repo.preload(:tags)
    render conn, "show.html", article: article, all_tags: all_tags
  end

  def tagshow(conn, %{"id" => id, "page" => page}) do
    user = Session.current_user(conn)
    all_tags = Repo.all(Tag)
    pages =  Article
    |> Article.has_tag(id)
    |> Article.show_order()
    |> Article.show_limit(user)
    |> Repo.paginate(page: page)
    render conn, "index.html", pages: pages, all_tags: all_tags
  end

  def tagshow(conn, %{"id" => id}) do
    user = Session.current_user(conn)
    all_tags = Repo.all(Tag)
    pages =  Article
    |> Article.has_tag(id)
    |> Article.show_order()
    |> Article.show_limit(user)
    |> Repo.paginate()
    render conn, "index.html", pages: pages, all_tags: all_tags
  end

  def new(conn, _params) do
    changeset = %Article{}
    |> Repo.preload(:tags)
    |> Article.changeset()
    all_tags = Repo.all(Tag)
    render(conn, "new.html", changeset: changeset, all_tags: all_tags)
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)
    case Repo.transaction(fn ->
        article = Repo.insert!(changeset)
        for tag_id <- article_params["tag_ids"] do
          tag_article_changeset = TagArticle.changeset(
            %TagArticle{},
            %{"tag_id" => tag_id, "article_id" => article.id}
            )
          Repo.insert!(tag_article_changeset)
        end
        article
      end) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :show, article))
        {:error, _}->
          all_tags = Repo.all(Tag)
          render(conn, "new.html", changeset: changeset, all_tags: all_tags)
    end
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get(Article, id)
    |> Repo.preload(:tags)
    all_tags = Repo.all(Tag)
    changeset = Article.changeset(article)
    render(
      conn,
      "edit.html",
      article: article,
      all_tags: all_tags,
      changeset: changeset
      )
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Repo.get(Article, id)
    changeset = Article.changeset(article, article_params)
    case Repo.transaction(fn ->
        from(ta in TagArticle, where: ta.article_id == ^id)
        |> Repo.delete_all
        article = Repo.update!(changeset)
        for tag_id <- article_params["tag_ids"] do
          tag_article_changeset = TagArticle.changeset(
            %TagArticle{},
            %{"tag_id" => tag_id, "article_id" => article.id}
            )
          Repo.insert!(tag_article_changeset)
        end
        article
      end) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article update successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, _}->
          all_tags = Repo.all(Tag)
          render(conn, "edit.html", changeset: changeset, all_tags: all_tags)
    end
  end

  defp check_status(conn, _params) do
    user = Session.current_user(conn)
    article = Repo.get!(Article, conn.params["id"])
    if is_nil(user) do
      if article.status != Article.get_status(:public) do
        conn
        |> put_flash(:info, "You can't read this article.")
        |> redirect(to: page_path(conn, :index))
      else
        conn
      end
    else
      conn
    end
  end


end
