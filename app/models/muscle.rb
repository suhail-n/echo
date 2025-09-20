class Muscle < ApplicationRecord
  has_many :exercise_muscles, dependent: :destroy
  has_many :exercises, through: :exercise_muscles

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
