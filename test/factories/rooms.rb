FactoryBot.define do
  factory :room do
    name { "MyString" }
    description { "MyText" }
    invitation_code { "MyString" }
    created_by { nil }
  end
end
