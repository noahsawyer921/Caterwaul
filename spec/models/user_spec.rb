require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, email: "user2@test.com")}
  let!(:room1) { create(:room) }
  let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }

  it "is valid with valid email and password" do
    expect(user1).to be_valid
  end

  it "is invalid with valid email and invalid password" do
    expect(build(:user, email: "valid_pass@test.com", password: "1")).to_not be_valid
  end

  it "has a unique email" do
    expect(build(:user, email: "test@test.com")).to_not be_valid
  end

  it "can tell if it is a member of a room" do
    expect(user1.is_member?(room1)).to be_truthy
  end

  it "can tell if it is not a member of a room" do
    expect(user1.is_member?(create(:room, name: "nonmember_room"))).to be_falsey
  end
end
