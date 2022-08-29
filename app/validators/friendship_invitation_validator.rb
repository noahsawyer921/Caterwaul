class FriendshipInvitationValidator < ActiveModel::Validator
  def validate(record)
    if Friendship.find_by(user: record.sender, friend: record.recipient)
      record.errors.add :base, "Those users are already friends"
      false
    else
      true
    end
  end
end
