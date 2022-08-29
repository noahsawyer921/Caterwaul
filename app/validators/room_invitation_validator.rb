class RoomInvitationValidator < ActiveModel::Validator
  def validate(record)
    if RoomMembership.find_by(room: record.invited_room, user: record.user)
      record.errors.add :base, "This user is already a member of that room"
      false
    else
      true
    end
  end
end
