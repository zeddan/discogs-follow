FactoryBot.define do
  factory :user do
    email { "example@email.com" }
    password_digest { "Password111!!!" }
  end
end
