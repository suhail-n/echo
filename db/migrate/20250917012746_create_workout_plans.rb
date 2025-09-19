class CreateWorkoutPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_plans do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.boolean :is_template, null: false, default: false
      t.boolean :is_published, null: false, default: false

      t.timestamps
    end
  end
end
