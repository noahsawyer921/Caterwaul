class RoomMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :room, uniqueness: {scope: :user}
  after_create_commit :broadcast_created
  after_destroy_commit :broadcast_destroyed

  def broadcast_created
    broadcast_append_to("app_#{user.id}", target: "room_list")
  end

  def broadcast_destroyed
    broadcast_remove_to("app_#{user.id}")
  end
end
