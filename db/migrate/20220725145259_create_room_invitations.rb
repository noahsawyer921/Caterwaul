class CreateRoomInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :room_invitations do |t|
      t.belongs_to :invited_room, null: false, foreign_key: {to_table: :rooms}
      t.belongs_to :user, null: false, foreign_key: {to_table: :users}
      t.index [:invited_room_id, :user_id], unique: true
    end
  end
end
