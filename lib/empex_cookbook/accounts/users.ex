defmodule EmpexCookbook.Accounts.Users do
  @moduledoc """
  The boundry for the Users system
  """

  alias EmpexCookbook.Repo
  alias EmpexCookbook.Accounts.User
  alias EmpexCookbook.Accounts.UserFollower

  def get_user!(id), do: Repo.get!(User, id)
  def get_by_username(username), do: Repo.get_by(User, username: username)

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def follow(user, followee) do
    %UserFollower{}
    |> UserFollower.changeset(%{user_id: user.id, followee_id: followee.id})
    |> Repo.insert()
  end

  def unfollow(user, followee) do
    relation =
      UserFollower
      |> Repo.get_by(user_id: user.id, followee_id: followee.id)

    case relation do
      nil ->
        false

      relation ->
        Repo.delete(relation)
    end
  end

  def is_following?(user, followee) do
    if user != nil && followee != nil do
      UserFollower |> Repo.get_by(user_id: user.id, followee_id: followee.id) != nil
    else
      nil
    end
  end
end
