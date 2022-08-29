require "rails_helper"

RSpec.describe Room, type: :model do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }
  let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }

  it "is valid with valid name" do
    expect(room1).to be_valid
  end

  it "has a unique name" do
    room2 = build(:room, name: "Room 1")
    expect(room2).to_not be_valid
  end

  it "can tell if it has a member user" do
    expect(room1.has_member?(user1)).to be_truthy
  end

  it "can tell if it does not have a member user" do
    user2 = create(:user, email: "nonmember@test.com")
    expect(room1.has_member?(user2)).to be_falsey
  end
end
