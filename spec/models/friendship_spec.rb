require "rails_helper"

RSpec.describe Friendship, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, email: "user2@test.com") }
  let!(:friendship1) { create(:friendship, user: user1, friend: user2) }

  it "creates a parallel friendship when a valid friendship is created" do
    expect(Friendship.count).to eq(2)
  end

  it "destroys the parallel friendship when a friendship is destroyed" do
    expect(Friendship.destroy_all.count).to eq(2)
  end

  it "does not allow duplicates" do
    friendship2 = build(:friendship, user: user1, friend: user2)
    expect(friendship2).to_not be_valid
  end

  it "invalidates duplicate friendships when trying to create the parallel friendship manually" do
    friendship2 = build(:friendship, user: user2, friend: user1)
    expect(friendship2).to_not be_valid
  end

  it "does not create extra friendships when trying to create the parallel friendship manually" do
    friendship2 = build(:friendship, user: user2, friend: user1)
    expect(Friendship.count).to eq(2)
  end
end
