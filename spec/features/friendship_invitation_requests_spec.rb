require "rails_helper"

RSpec.describe "FriendshipInvitations", type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, email: "user2@test.com") }
  let(:friendship1) { create(:friendship, user: user1, friend: user2) }

  it "Should get an error from create with invalid params" do
    expect { post "/friendship_invitations", params: {friendship_invitation: {}} }.to raise_error(ActionController::ParameterMissing)
  end

  it "Should get a created response with a proper creation" do
    post "/friendship_invitations", params: {friendship_invitation: {sender_id: user1.id, recipient_id: user2.id}}
    expect(response.status).to eql(201)
  end

  it "Should get a created response on sending an invitation if logged in, not friends, and sent to a valid user email" do
    sign_in(user1, scope: :user)
    post "/friendship_invitations/send_invitation", params: {friendship_invitation: {email: user2.email}}
    expect(response.status).to eql(201)
  end

  it "Should get an unprocessable response on sending an invitation if logged in, not friends, and sent to an invalid email" do
    sign_in(user1, scope: :user)
    post "/friendship_invitations/send_invitation", params: {friendship_invitation: {email: "not_a_user@test.com"}}
    expect(response.status).to eql(422)
  end

  it "Should get an unauthorized response on sending an invitation an inivtation when not logged in" do
    post "/friendship_invitations/send_invitation", params: {friendship_invitation: {email: user2.email}}
    expect(response.status).to eql(401)
  end

  describe "with an existing friendship" do
    let!(:friendship1) { create(:friendship, user: user1, friend: user2) }
    it "Should get an unprocessable response on sending an invitation already friends" do
      sign_in(user1, scope: :user)
      post "/friendship_invitations/send_invitation", params: {friendship_invitation: {email: user2.email}}
      expect(response.status).to eql(422)
    end
  end

  describe "with an existing friendship invitation" do
    let!(:friendship_invitation1) { create(:friendship_invitation, sender: user1, recipient: user2) }

    it "Should get an unauthorized response on trying to accept if not logged in" do
      post "/friendship_invitations/#{friendship_invitation1.id}/accept"
      expect(response.status).to eql(401)
    end

    it "Should get an unauthorized response on trying to decline if not logged in" do
      post "/friendship_invitations/#{friendship_invitation1.id}/decline"
      expect(response.status).to eql(401)
    end

    it "Should get a forbidden response on trying to accept if logged in as someone other than the recipient" do
      sign_in(user1, scope: :user)
      post "/friendship_invitations/#{friendship_invitation1.id}/accept"
      expect(response.status).to eql(403)
    end

    it "Should get a forbidden response on trying to decline if logged in as someone other than the recipient" do
      sign_in(user1, scope: :user)
      post "/friendship_invitations/#{friendship_invitation1.id}/decline"
      expect(response.status).to eql(403)
    end

    it "Should get a created response on accepting if logged in as the recipient" do
      sign_in(user2, scope: :user)
      post "/friendship_invitations/#{friendship_invitation1.id}/accept"
      expect(response.status).to eql(201)
    end

    it "Should get an ok response on declining if logged in as the recipient" do
      sign_in(user2, scope: :user)
      post "/friendship_invitations/#{friendship_invitation1.id}/decline"
      expect(response.status).to eql(200)
    end

    it "Should get an unprocessable response on sending an invitation an inivtation already exists" do
      sign_in(user1, scope: :user)
      post "/friendship_invitations/send_invitation", params: {friendship_invitation: {email: user2.email}}
      expect(response.status).to eql(422)
    end

    it "Should get a conflict response on accepting an invitation when the users are already friends" do
      sign_in(user2, scope: :user)
      friendship1
      post "/friendship_invitations/#{friendship_invitation1.id}/accept"
      expect(response.status).to eql(409)
    end

    it "Should get an unprocessable response with an improper creation" do
      # This is improper due to being a duplicate
      post "/friendship_invitations", params: {friendship_invitation: {sender_id: user1.id, recipient_id: user2.id}}
      expect(response.status).to eql(422)
    end
  end
end
