class RoomInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :invited_room, class_name: "Room", foreign_key: "invited_room_id"
  validates :invited_room, uniqueness: {scope: :user}
  validates_with RoomInvitationValidator
  after_create_commit :broadcast_created
  after_destroy_commit :broadcast_destroyed

  def broadcast_created
    broadcast_append_to("app_#{user_id}",
      target: "room_invite_list")
  end

  def broadcast_destroyed
    broadcast_remove_to("app_#{user_id}")
  end

  def accept
    membership = RoomMembership.new(room: invited_room, user: user)
    if membership.save
      destroy
      membership
    end
  end

  def decline
    destroy
    nil
  end

  def email=(value)
    self.user = User.find_by(email: value)
  end
end
