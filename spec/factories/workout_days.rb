FactoryBot.define do
  factory :workout_day do
    WorkoutPlan { nil }
    name { "MyString" }
    order { 1 }
  end
end
