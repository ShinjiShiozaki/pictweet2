FactoryBot.define do
  factory :mtweet do
    text {Faker::Lorem.sentence}
    image {Faker::Lorem.sentence}
    association :user 
  end
end
