class Exercise < ApplicationRecord
  has_many :exercise_muscles, dependent: :destroy
  has_many :muscles, through: :exercise_muscles
  has_many :workout_day_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
