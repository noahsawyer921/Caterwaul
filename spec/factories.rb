FactoryBot.define do
  factory :friendship_invitation do
    sender { create(:user, email: "frienship_invitation_sender@test.com") }
    recipient { create(:user, email: "frienship_invitation_recipient@test.com") }
  end

  factory :friendship do
    user { create(:user, email: "frienship_user@test.com") }
    friend { create(:user, email: "frienship_friend@test.com") }
  end

  factory :room_invitation do
    invited_room { create(:room, name: "room_invitation_test_room") }
    user { create(:user, email: "room_invitation_test_user@test.com") }
  end

  factory :message do
    body { "MyString" }
    user { create(:user, email: "message_test_user@test.com") }
    room { create(:room, name: "message_test_room") }
  end

  factory :room_membership do
    room { create(:room, name: "room_membership_test_room") }
    user { create(:user, email: "room_membership_test_user@test.com") }
  end

  factory :user do
    email { "test@test.com" }
    password { "123456" }
  end
  factory :room do
    name { "Room 1" }
  end
end
