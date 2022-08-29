class RoomInvitationsController < ApplicationController
  before_action :set_room_invitation, only: [:accept, :decline]
  before_action :authorize_logged_in, only: [:send_invitation]
  before_action :authorize_user_can_send_invitation, only: [:send_invitation]

  def create
    @room_invitation = RoomInvitation.new(room_invitation_params)
    if @room_invitation.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def send_invitation
    room_invitation = RoomInvitation.new(room_invitation_send_params)
    if room_invitation.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def accept
    if current_user != @room_invitation.user
      render "shared/home", status: :unauthorized
      return nil
    end

    if @room_invitation.accept
      head :created
    else
      head :conflict
    end
  end

  def decline
    if current_user != @room_invitation.user
      render "shared/home", status: :unauthorized
      return nil
    end

    @room_invitation.decline
    head :ok
  end

  private

  def set_room_invitation
    @room_invitation = RoomInvitation.find(params[:room_invitation_id])
  end

  def room_invitation_params
    params.require(:room_invitation).permit(:invited_room_id, :user_id)
  end

  def room_invitation_send_params
    params.require(:room_invitation).permit(:email, :invited_room_id)
  end

  def authorize_user_can_send_invitation
    if !current_user.is_member?(Room.find(room_invitation_send_params[:invited_room_id]))
      head :forbidden
    end
  end
end
