class CreateWorkoutDays < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_days do |t|
      t.references :workout_plan, null: false, foreign_key: true
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
