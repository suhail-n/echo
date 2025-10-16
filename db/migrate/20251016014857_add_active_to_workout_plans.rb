class AddActiveToWorkoutPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_plans, :active, :boolean, default: false, null: false
  end
end
