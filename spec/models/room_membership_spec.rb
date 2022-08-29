require "rails_helper"

RSpec.describe RoomMembership, type: :model do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }
  let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }

  it "is valid with valid user and room" do
    expect(room_membership1).to be_valid
  end

  it "is a unique pair" do
    room_membership2 = build(:room_membership, room: room1, user: user1)
    expect(room_membership2).to_not be_valid
  end

  it "does not block multiple connections to the same room" do
    user2 = create(:user, email: "test2@test.com")
    room_membership2 = create(:room_membership, room: room1, user: user2)
    expect(room_membership2).to be_valid
  end

  it "does not block multiple connections by a single user" do
    room2 = create(:room, name: "Room 2")

    room_membership2 = create(:room_membership, room: room2, user: user1)
    expect(room2).to be_valid
  end
end
