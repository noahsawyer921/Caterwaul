require "rails_helper"

RSpec.describe "RoomRequests", type: :request do
  let!(:user1) { create(:user) }
  let!(:room1) { create(:room) }

  it "Should get a response from new" do
    get "/rooms/new", params: {}
    expect(response.status).to eql(200)
  end

  it "Should get an error from create with no params" do
    sign_in(user1, scope: :user)
    expect { post "/rooms", params: {room: {}} }.to raise_error(ActionController::ParameterMissing)
  end

  it "Should get an unprocessable response from create with duplicate params" do
    sign_in(user1, scope: :user)
    post "/rooms", params: {room: {name: "Room 1"}}
    expect(response.status).to eql(422)
  end

  it "Should get a created response from create with valid params" do
    sign_in(user1, scope: :user)
    post "/rooms", params: {room: {name: "Room 100"}}
    expect(response.status).to eql(201)
  end

  it "Should get a forbidden response from destroy when signed in as a non-member of the room" do
    sign_in(user1, scope: :user)
    delete "/rooms/#{room1.id}", params: {}
    expect(response.status).to eql(403)
  end

  it "Should get an ok response from joining when valid" do
    sign_in(user1, scope: :user)
    post "/rooms/#{room1.id}/join", params: {id: room1.id}
    expect(response.status).to eql(200)
  end



  it "Should still identify the correct room when given a room_id instead of just an id" do
    sign_in(user1, scope: :user)
    post "/rooms/#{room1.id}/join", params: {room_id: room1.id}
    expect(response.status).to eql(200)
  end

  it "Should get a not_found response from leaving a room when signed in as a non-member" do
    sign_in(user1, scope: :user)
    delete "/rooms/#{room1.id}/leave"
    expect(response.status).to eql(404)
  end


  describe "with a room membership" do
    let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }

    it "Should get a found response from destroy" do
      sign_in(user1, scope: :user)
      delete "/rooms/#{room1.id}", params: {}
      expect(response.status).to eql(302)
    end

    it "Should get an unauthorized response from destroy when not signed in" do
      delete "/rooms/#{room1.id}", params: {}
      expect(response.status).to eql(401)
    end

    it "Should get a conflict response from joining twice" do
      sign_in(user1, scope: :user)
      post "/rooms/#{room1.id}/join", params: {id: room1.id}
      expect(response.status).to eql(409)
    end

    it "Should get an unauthorized response from leaving a room when not signed in" do
      delete "/rooms/#{room1.id}/leave"
      expect(response.status).to eql(401)
    end

    it "Should get an ok response from leaving a room when signed in as its member" do
      sign_in(user1, scope: :user)
      delete "/rooms/#{room1.id}/leave"
      expect(response.status).to eql(200)
    end
  end
end
