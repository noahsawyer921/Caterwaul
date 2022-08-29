class FriendshipInvitation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  validates :sender, uniqueness: {scope: :recipient}
  validates_with FriendshipInvitationValidator
  after_create_commit :broadcast_created
  after_destroy_commit :broadcast_destroyed
  def accept
    friendship = Friendship.new(user: sender, friend: recipient)
    if friendship.save
      destroy
      friendship
    end
  end

  def decline
    destroy
    nil
  end

  def broadcast_created
    broadcast_append_to("app_#{recipient.id}", target: "friend_invite_list")
    broadcast_append_to("app_#{sender.id}", target: "friend_invite_list", partial: "friendship_invitations/friendship_invitation_sender")
  end

  def broadcast_destroyed
    broadcast_remove_to("app_#{recipient.id}", target: self)
    broadcast_remove_to("app_#{sender.id}", target: self)
  end

  def email=(value)
    self.recipient = User.find_by(email: value)
  end
end
