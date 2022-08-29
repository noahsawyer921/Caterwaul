class RoomsController < ApplicationController
  before_action :set_room, only: [:destroy, :join, :change_room]
  before_action :authorize_logged_in, only: [:create, :destroy, :join, :leave, :change_room]
  before_action :authorize_has_member, only: [:destroy, :change_room]
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      @room.room_memberships.create(user: current_user)
      head :created
    else
      head :unprocessable_entity
    end
  end

  def destroy
    set_room
    @room.destroy
    redirect_to root_url
  end

  def join
    set_room

    if current_user&.join_room(@room)
      head :ok
    else
      head :conflict
    end
  end

  def leave
    set_room

    if current_user&.leave_room(@room).any?
      render turbo_stream: turbo_stream.replace("chat_room", partial: "shared/empty_chat")
    else
      head :not_found
    end
  end

  def change_room
    set_current_room(@room)
    render partial: "shared/chat_room", locals: {room: @room}
  end

  private

  def set_room
    @room ||= Room.find(params[:id] || params[:room_id])
  end

  def room_params
    params.require(:room).permit(:name)
  end

  def authorize_has_member
    if !@room.has_member?(current_user)
      render "shared/home", status: :forbidden
    end
  end
end
