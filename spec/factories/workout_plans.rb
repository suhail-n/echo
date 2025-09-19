FactoryBot.define do
  factory :workout_plan do
    name { Faker::Name.name }
    user { nil }
    is_template { false }
    is_published { false }
  end
end
