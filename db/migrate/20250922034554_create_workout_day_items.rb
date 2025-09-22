class CreateWorkoutDayItems < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_day_items do |t|
      t.references :workout_day, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :order
      t.integer :superset_group
      t.integer :planned_sets
      t.integer :planned_reps

      t.timestamps
    end
  end
end
