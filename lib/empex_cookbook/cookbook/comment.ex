defmodule EmpexCookbook.Cookbook.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias EmpexCookbook.Cookbook.Comment
  alias EmpexCookbook.Cookbook.Article
  alias EmpexCookbook.Accounts.User

  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(body user_id article_id)a

  schema "comments" do
    field(:body, :string)

    belongs_to(:article, Article, foreign_key: :article_id)
    belongs_to(:author, User, foreign_key: :user_id)
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, @required_fields)
    |> validate_required([:body])
    |> assoc_constraint(:author)
  end
end
