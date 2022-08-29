require "rails_helper"

RSpec.describe RoomMembership, type: :model do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }
  let!(:message1) { create(:message, room: room1, user: user1) }

  it "is valid with valid user and room" do
    expect(message1).to be_valid
  end

  it "is not unique" do
    message2 = build(:message, room: room1, user: user1)
    expect(message2).to be_valid
  end
end
