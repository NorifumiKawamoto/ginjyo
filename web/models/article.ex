defmodule Ginjyo.Article do
  use Ginjyo.Web, :model

  alias Ginjyo.User
  alias Ginjyo.TagArticle
  alias Ginjyo.Article
  alias Ecto.Changeset

  @status %{:draft => 0, :private => 1, :public => 2, :members_only => 3}
  @status_name %{0 => "draft", 1 => "private", 2 => "public", 3 => "members_only"}

  def get_status do
    @status
  end

  def get_status(key) do
    @status[key]
  end

  def get_status_name(key) do
    @status_name[key]
  end


  schema "articles" do
    field :title, :string
    field :body, :string
    field :thumbnail_path, :string
    field :status, :integer
    belongs_to :user, User
    has_many :tag_articles, TagArticle
    has_many :tags, through: [:tag_articles, :tag]
    field :tag_ids, {:array, :integer}, virtual: true

    timestamps
  end

  @required_fields ~w(title body status)
  @optional_fields ~w(tag_ids thumbnail_path)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:title)
    |> validate_length(:tag_ids, min: 1)
    |> validate_inclusion(:status, [0, 1, 2, 3])
    |> has_tags?
  end

  defp has_tags?(changeset) do
    tag_ids = Changeset.get_field(changeset, :tag_ids)
    if is_list(tag_ids) do
      if Enum.empty?(tag_ids) do
        add_error changeset , :tag_ids, "Nill List"
      else
        changeset
      end
    else
      add_error changeset , :tag_ids, "Not List"
    end
  end

  def show_order(query) do
    from a in query,
    order_by: [desc: a.updated_at]
  end

  def show_limit(query, user \\ :empty) do
    if is_nil(user) || Enum.empty?(user) do
      from a in query,
      where: a.status == ^Article.get_status(:public)
    else
      query
    end
  end

  def has_tag(query, tag_id) do
    from a in query,
    join: t in assoc(a, :tags),
    where: t.id == ^tag_id
  end
end
