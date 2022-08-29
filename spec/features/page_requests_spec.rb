require "rails_helper"

RSpec.describe "PageRequests", type: :request do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }
  let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }

  it "Should get a response from the root_url" do
    get "/", params: {}
    expect(response.status).to eql(200)
  end

  it "Should not redirect to app if not signed in" do
    get "/app", params: {}
    expect(response.status).to eql(401)
  end

  it "Should complete and render app if signed in" do
    sign_in(user1, scope: :user)
    get "/app", params: {}
    expect(response.status).to eql(200)
  end

  it "Should complete and render app if signed in to a user with rooms" do
    sign_in(user1, scope: :user)
    get "/app", params: {}
    expect(response.status).to eql(200)
  end
  it "Should respond with ok when changing rooms when signed in and a member" do
    sign_in(user1, scope: :user)
    get "/room/change", params: {room_id: room1.id}
    expect(response.status).to eql(200)
  end
  it "Should respond with forbidden when changing rooms when signed in and not a member" do
    sign_in(user1, scope: :user)
    get "/room/change", params: {room_id: create(:room, name: "test_change_fail_room").id}
    expect(response.status).to eql(403)
  end
end
