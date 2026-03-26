FactoryBot.define do
  factory :comment do
    association :post
    author_name { Faker::Name.name }
    body        { Faker::Lorem.sentences(number: 2).join(" ") }
  end
end
