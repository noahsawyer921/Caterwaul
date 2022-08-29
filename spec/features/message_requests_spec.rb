require "rails_helper"

RSpec.describe "MessageRequests", type: :request do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }
  let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }
  let!(:message1) { create(:message, user: user1) }

  it "Should get an ok response with a proper creation" do
    sign_in(user1, scope: :user)
    post "/messages", params: {message: {room_id: room1.id, user_id: user1.id, body: "1"}}, headers: {"HTTP_REFERER" => "/"}
    expect(response.status).to eql(200)
  end

  it "Should not prevent duplicates" do
    sign_in(user1, scope: :user)
    post "/messages", params: {message: {room_id: room1.id, user_id: user1.id, body: "1"}}
    post "/messages", params: {message: {room_id: room1.id, user_id: user1.id, body: "1"}}
    expect(response.status).to eql(200)
  end

  it "Should be unprocessable with invalid params" do
    sign_in(user1, scope: :user)
    post "/messages", params: {message: {user_id: user1.id, body: "1"}}, headers: {"HTTP_REFERER" => "/"}
    expect(response.status).to eql(422)
  end

  it "Should get a found response from valid destroy" do
    sign_in(user1, scope: :user)
    delete "/messages/#{message1.id}", params: {}
    expect(response.status).to eql(302)
  end

  it "Should get a forbidden response from destroy when not signed in" do
    delete "/messages/#{message1.id}", params: {}
    expect(response.status).to eql(403)
  end

  it "Should get a forbidden response from destroy when signed in as a different user" do
    sign_in(create(:user, email: "test2@test.com"), scope: :user)
    delete "/messages/#{message1.id}", params: {}
    expect(response.status).to eql(403)
  end
end
