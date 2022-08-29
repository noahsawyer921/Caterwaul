class ApplicationController < ActionController::Base
  before_action :authorize_logged_in, only: [:app]
  def home
    render "shared/home"
  end

  def app
    if current_user.rooms.any?
      set_current_room(current_user.rooms.first)
    end

    render "shared/app"
  end

  def set_current_room(room)
    session[:current_room_id] = room.id
  end
  helper_method :set_current_room

  def current_room
    Room.find_by(id: session[:current_room_id])
  end
  helper_method :current_room

  # :nocov:
  def after_sign_in_path_for(resource)
    app_path
  end
  # :nocov:

  private

  def authorize_logged_in
    if !current_user
      render "shared/home", status: :unauthorized
    end
  end
end
