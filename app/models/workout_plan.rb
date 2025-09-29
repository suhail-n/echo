class WorkoutPlan < ApplicationRecord
  belongs_to :user
  has_many :workout_days, -> { order(:order) }, dependent: :destroy
  has_many :workout_day_items, through: :workout_days
  accepts_nested_attributes_for :workout_days, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validate :must_have_at_least_one_workout_day

  private

  def must_have_at_least_one_workout_day
    if workout_days.empty? || workout_days.all? { |day| day.marked_for_destruction? }
      errors.add(:workout_days, "must have at least one workout day")
    end
  end
end
