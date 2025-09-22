class ExerciseMuscle < ApplicationRecord
  belongs_to :exercise
  belongs_to :muscle

  enum :role, { primary: "primary", secondary: "secondary" }, suffix: true
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :exercise_id, uniqueness: { scope: [ :muscle_id, :role ] }
end
