class WorkoutDay < ApplicationRecord
  belongs_to :workout_plan
  has_many :workout_day_items, dependent: :destroy

  validates :name, presence: true
  validates :order, presence: true, numericality: { only_integer: true }
end
