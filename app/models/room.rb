class Room < ApplicationRecord
  validates :name, uniqueness: true
  has_many :room_memberships
  has_many :users, through: :room_memberships, source: :user, dependent: :destroy
  has_many :messages

  def has_member?(user)
    room_memberships.find_by(user: user)
  end
end
