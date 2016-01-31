# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ginjyo.Repo.insert!(%Ginjyo.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ginjyo.Repo
alias Ginjyo.Role
alias Ginjyo.User
alias Ginjyo.Article
alias Ginjyo.Tag
alias Ginjyo.TagArticle

import Ecto.Query, only: [from: 2]

find_or_create_role = fn role_name, rank ->
  case Repo.all(
  from r in Role,
  where: r.name == ^role_name and r.rank == ^rank
  ) do
    [] ->
      %Role{}
      |> Role.changeset(%{name: role_name, rank: rank})
     |> Repo.insert()
    _ ->
      IO.puts "Role: #{role_name} already exists, skipping"
  end
end

find_or_create_user = fn email, role ->
  case Repo.all(from u in User, where: u.email == ^email) do
    [] ->
      %User{}
      |> User.changeset(
        %{
          email: email,
          password: "test1234",
          password_confirmation: "test1234",
          role_id: role.id
        }
      )
      |> Repo.insert()
    _ ->
      IO.puts "User: #{email} already exists, skipping"
  end
end

find_or_create_tag = fn name, slug ->
  case Repo.all(from t in Tag, where: t.slug == ^slug and t.name == ^name) do
    [] ->
      %Tag{}
      |> Tag.changeset(%{name: name, slug: slug})
      |> Repo.insert()
    _ ->
      IO.puts "Tag: #{name} already exists, skipping"
  end
end

find_or_create_article = fn title, body, user, tag_ids ->
  case Repo.all(from a in Article, where: a.title == ^title) do
    [] ->
      {:ok, article} = %Article{}
      |> Article.changeset(
        %{
          title: title,
          body: body,
          thumbnail_path: "/images/logo.png",
          status: Article.get_status(:public),
          user_id: user.id,
          tag_ids: tag_ids
          }
        )
      |> Repo.insert()
      for tag_id <- tag_ids do
        tag_article_changeset = TagArticle.changeset(
          %TagArticle{},
          %{"tag_id" => tag_id, "article_id" => article.id}
          )
        Repo.insert(tag_article_changeset)
      end
    _ ->
      IO.puts "Article: #{title} already exists, skipping"
  end
end

{:ok, _user_role} = find_or_create_role.("User Role", 0)
{:ok, admin_role}  = find_or_create_role.("Admin Role", 10)
{:ok, usr}  = find_or_create_user.("test@test.com", _user_role)
{:ok, usr2} = find_or_create_user.("admin@test.com", admin_role)

{:ok, tag} = find_or_create_tag.("Elixir", "elixir")
{:ok, tag2} = find_or_create_tag.("Phoenix", "phoenix")
{:ok, tag3} = find_or_create_tag.("Processing", "processing")
{:ok, tag4} = find_or_create_tag.("ios", "ios")
{:ok, tag5} = find_or_create_tag.("Android", "android")

dummy_texts = {
  "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,",
  "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure? On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee",
  "One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin. He lay on his armour-like back, and if he lifted his head a little he could see his brown belly, slightly domed and divided by arches into stiff sections. The bedding was hardly able to cover it and seemed ready to slide off any moment. His many legs, pitifully thin compared with the size of the rest of him, waved about helplessly as he looked. \"What's happened to me?\" he thought. It wasn't a dream. His room, a proper human room although a little too small, lay peacefully between its four familiar walls. A collection of textile samples lay spread out on the table - Samsa was a travelling salesman - and above it there hung a picture that he had recently cut out of an illustrated magazine and housed in a nice, gilded frame. It showed a lady fitted out with a fur hat and fur boa who sat upright, raising a heavy fur muff that covered the whole of her lower arm towards the viewer. Gregor then turned to look out the window at the dull weather. Drops"
}

Enum.map(1..12,
  fn n ->
    find_or_create_article.("title1_#{n}", "#{n}" <> elem(dummy_texts, 0), usr, [tag.id, tag2.id, tag3.id])
    find_or_create_article.("title2_#{n}", "#{n}" <> elem(dummy_texts, 1), usr2, [tag4.id, tag5.id])
  end
)
