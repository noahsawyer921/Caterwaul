class CreateRoomMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :room_memberships do |t|
      t.belongs_to :room, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.index [:room_id, :user_id], unique: true
      t.timestamps
    end
  end
end
