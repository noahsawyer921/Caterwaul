Rails.application.routes.draw do
  devise_for :users
  resources :friendship_invitations, only: [:create] do
    post "accept", to: "friendship_invitations#accept"
    post "decline", to: "friendship_invitations#decline"
  end
  scope :friendship_invitations do
    post "send_invitation", to: "friendship_invitations#send_invitation"
  end
  resources :room_invitations, only: [:create] do
    post "accept", to: "room_invitations#accept"
    post "decline", to: "room_invitations#decline"
  end
  scope :room_invitations do
    post "send_invitation", to: "room_invitations#send_invitation"
  end
  resources :rooms, only: [:create, :new, :destroy] do
    post "join", to: "rooms#join"
    delete "leave", to: "rooms#leave"
  end
  resources :messages, only: [:create, :destroy]

  scope :room do
    get "/change", to: "rooms#change_room", as: "change_room"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "application#home"
  get "/app", to: "application#app"

end
