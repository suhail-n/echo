FactoryBot.define do
  factory :workout_day_item do
    workout_day { nil }
    exercise { nil }
    order { 1 }
    superset_group { 1 }
    planned_sets { 1 }
    planned_reps { 1 }
  end
end
