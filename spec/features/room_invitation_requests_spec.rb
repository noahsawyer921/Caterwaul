require "rails_helper"

RSpec.describe "RoomInvitations", type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, email: "user2@test.com") }
  let!(:room1) { create(:room) }
  let!(:room_invitation1) { create(:room_invitation, user: user1, invited_room: room1) }


  it "Should get an error from create with invalid params" do
    expect { post "/room_invitations", params: {room_invitation: {}} }.to raise_error(ActionController::ParameterMissing)
  end

  it "Should get a created response with a proper creation" do
    post "/room_invitations", params: {room_invitation: {invited_room_id: create(:room, name: "invitation_test").id, user_id: user1.id}}
    expect(response.status).to eql(201)
  end

  it "Should get an unprocessable response with an improper creation" do
    # This is improper due to being a duplicate
    post "/room_invitations", params: {room_invitation: {invited_room_id: room1.id, user_id: user1.id}}
    expect(response.status).to eql(422)
  end

  it "Should fail to accept if not logged in" do
    post "/room_invitations/#{room_invitation1.id}/accept"
    expect(response.status).to eql(401)
  end

  it "Should fail to decline if not logged in" do
    post "/room_invitations/#{room_invitation1.id}/decline"
    expect(response.status).to eql(401)
  end

  it "Should get a created response if logged in to the correct account" do
    sign_in(user1, scope: :user)
    post "/room_invitations/#{room_invitation1.id}/accept"
    expect(response.status).to eql(201)
  end

  it "Should give an ok response on a decline if logged in to the correct account" do
    sign_in(user1, scope: :user)
    post "/room_invitations/#{room_invitation1.id}/decline"
    expect(response.status).to eql(200)
  end

  it "Should destroy the invitation on a decline when logged in to the correct account" do
    sign_in(user1, scope: :user)
    post "/room_invitations/#{room_invitation1.id}/decline"
    expect { room_invitation1.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "Should get a forbidden response after sending an invitation to a server that the user is not a member of" do
    sign_in(user1, scope: :user)
    post "/room_invitations/send_invitation", params: {room_invitation: {email: user2.email, invited_room_id: room1.id}}
    expect(response.status).to eql(403)
  end

  it "Should get an unauthorized response after sending an invitation when not logged in" do
    post "/room_invitations/send_invitation", params: {room_invitation: {email: user1.email, invited_room_id: room1.id}}
    expect(response.status).to eql(401)
  end

  describe "with an existing membership" do
    let!(:room_membership1) { create(:room_membership, user: user1, room: room1) }

    it "Should get a conflict response if membership already exists" do
      sign_in(user1, scope: :user)
      post "/room_invitations/#{room_invitation1.id}/accept"
      expect(response.status).to eql(409)
    end

    it "Should get a created response after sending a valid invitation" do
      sign_in(user1, scope: :user)
      post "/room_invitations/send_invitation", params: {room_invitation: {email: user2.email, invited_room_id: room1.id}}
      expect(response.status).to eql(201)
    end

    it "Should get an unprocessable response after sending a duplicate invitation" do
      sign_in(user1, scope: :user)
      create(:room_invitation, user: user2, invited_room: room1)
      # this is invalid because it is creating a duplicate
      post "/room_invitations/send_invitation", params: {room_invitation: {email: user2.email, invited_room_id: room1.id}}
      expect(response.status).to eql(422)
    end
  end
end
