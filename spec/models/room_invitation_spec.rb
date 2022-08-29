require "rails_helper"

RSpec.describe RoomInvitation, type: :model do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }
  let!(:room_invitation1) { create(:room_invitation, user: user1, invited_room: room1) }

  it "is valid with valid user and room" do
    expect(room_invitation1).to be_valid
  end
  it "is able to be accepted" do
    membership = room_invitation1.accept
    expect(membership.class).to eq(RoomMembership)
  end
  it "to not generate a membership when declined" do
    membership = room_invitation1.decline
    expect(membership.class).to_not eq(RoomMembership)
  end
  it "is not valid when a user is already a room member" do
    create(:room_membership, user: user1, room: room1)
    expect(room_invitation1).to_not be_valid
  end
  it "is fully destroyed when declined" do
    room_invitation1.decline
    expect { room_invitation1.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
