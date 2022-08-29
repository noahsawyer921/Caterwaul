class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  validates :user, uniqueness: {scope: :friend}
  after_create_commit :create_parallel
  after_create_commit :broadcast_created
  after_destroy_commit :destroy_parallel
  after_destroy_commit :broadcast_destroyed

  def parallel
    @parallel ||= Friendship.find_by(user: friend, friend: user)
  end

  def create_parallel
    Friendship.find_or_create_by(user: friend, friend: user)
  end

  def destroy_parallel
    parallel&.destroy
  end

  def broadcast_created
    broadcast_append_to("app_#{user.id}", target: "friend_list")
  end

  def broadcast_destroyed
    broadcast_remove_to("app_#{user.id}", target: self)
  end
end
