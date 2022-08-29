require "rails_helper"

RSpec.describe FriendshipInvitation, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, email: "user2@test.com") }

  it "creates a valid friendship request if given an email instead of an id" do
    friendship_invitation2 = build(:friendship_invitation, email: "user2@test.com", sender: user1)
    expect(friendship_invitation2).to be_valid
  end

  describe "with an existing frienship" do
    let!(:friendship1) { create(:friendship, user: user1, friend: user2) }

    it "cannot be created if the two users are already friends" do
      expect(build(:friendship_invitation, sender: user1, recipient: user2)).to_not be_valid
    end
  end

  describe "with an existing friendship invitation" do
    let!(:friendship_invitation1) { create(:friendship_invitation, sender: user1, recipient: user2) }

    it "is destroyed if declined" do
      friendship_invitation1.decline
      expect { friendship_invitation1.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is destroyed if accepted" do
      friendship_invitation1.accept
      expect { friendship_invitation1.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "creates a pair of friendships when accepted" do
      friendship_invitation1.accept
      expect(Friendship.count).to eq(2)
    end

    it "does not create any friendships if declined" do
      friendship_invitation1.decline
      expect(Friendship.any?).to be_falsey
    end

    it "must be unique" do
      expect(build(:friendship_invitation, sender: user1, recipient: user2)).to_not be_valid
    end
  end
end
