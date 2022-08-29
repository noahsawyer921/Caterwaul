class MessagesController < ApplicationController
  before_action :set_message, only: [:destroy]
  before_action :authorize_message_owner, only: [:destroy]
  def create
    @message = current_user.messages.new(message_params)

    if @message.save
      @message.broadcast_append_to("messages_#{@message.room_id}", target: "message_list_#{@message.room_id}", partial: "messages/message", locals: {message: @message})
      head :ok
      # redirect_to request.referrer
    else
      render "shared/home", status: :unprocessable_entity
    end
  end

  def destroy
    set_message
    @message.destroy
    redirect_to root_url
  end

  private

  def set_message
    @message ||= Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :room_id)
  end

  def authorize_message_owner
    if @message.user != current_user
      render "shared/home", status: :forbidden
    end
  end
end
