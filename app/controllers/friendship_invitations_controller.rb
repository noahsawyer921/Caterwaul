class FriendshipInvitationsController < ApplicationController
  before_action :set_friendship_invitation, only: [:accept, :decline]
  before_action :authorize_logged_in, only: [:send_invitation, :accept, :decline]
  before_action :authorize_user_can_close_invitation, only: [:accept, :decline]

  def create
    @friendship_invitation = FriendshipInvitation.new(friendship_invitation_params)

    if @friendship_invitation.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def send_invitation
    friendship_invitation = FriendshipInvitation.new(friendship_invitation_send_params.merge(sender: current_user))

    if friendship_invitation.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def accept
    if @friendship_invitation.accept
      head :created
    else
      head :conflict
    end
  end

  def decline
    @friendship_invitation.decline
    head :ok
  end

  private

  def set_friendship_invitation
    @friendship_invitation = FriendshipInvitation.find(params[:friendship_invitation_id])
  end

  def friendship_invitation_params
    params.require(:friendship_invitation).permit(:sender_id, :recipient_id)
  end

  def friendship_invitation_send_params
    params.require(:friendship_invitation).permit(:email)
  end

  def authorize_user_can_close_invitation
    if current_user != @friendship_invitation.recipient
      head :forbidden
    end
  end
end
