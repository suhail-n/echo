class WorkoutPlan < ApplicationRecord
  belongs_to :user
  has_many :workout_days, -> { order(:order) }, dependent: :destroy
  has_many :workout_day_items, through: :workout_days

  validates :name, presence: true
end
