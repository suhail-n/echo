class WorkoutDayItem < ApplicationRecord
  belongs_to :workout_day
  belongs_to :exercise

  validates :planned_sets, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :planned_reps, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :order, numericality: { only_integer: true }, allow_nil: true
end
