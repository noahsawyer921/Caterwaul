class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  has_many :room_memberships
  has_many :rooms, through: :room_memberships, source: :room, dependent: :destroy
  has_many :room_invitations
  has_many :invited_rooms, through: :room_invitations, source: :invited_room, dependent: :destroy
  has_many :messages
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend, dependent: :destroy
  has_many :friendship_invitations, foreign_key: :recipient_id
  has_many :sent_friendship_invitations, class_name: FriendshipInvitation.to_s, foreign_key: :sender_id

  def join_room(room)
    membership = RoomMembership.new(room: room, user: self)
    membership.save
  end

  def leave_room(room)
    RoomMembership.destroy_by(room: room, user: self)
  end

  def is_member?(room)
    room_memberships.find_by(room: room)
  end
end
