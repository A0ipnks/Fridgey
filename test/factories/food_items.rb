FactoryBot.define do
  factory :food_item do
    name { "MyString" }
    category { 1 }
    expiration_date { "2025-09-30" }
    room { nil }
    registered_by { nil }
    used_by { nil }
    restriction_tags { "MyText" }
    memo { "MyText" }
  end
end
