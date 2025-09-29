class WorkoutDay < ApplicationRecord
  belongs_to :workout_plan
  has_many :workout_day_items, dependent: :destroy
  accepts_nested_attributes_for :workout_day_items, allow_destroy: true, reject_if: :all_blank
  default_scope { order(:order) }

  validates :name, presence: true
  validates :order, presence: true, numericality: { only_integer: true }
  validate :must_have_at_least_one_exercise

  private

  def must_have_at_least_one_exercise
    if workout_day_items.empty? || workout_day_items.all? { |item| item.marked_for_destruction? }
      errors.add(:workout_day_items, "must have at least one exercise")
    end
  end
end
