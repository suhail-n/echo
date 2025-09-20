class CreateExerciseMuscles < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_muscles do |t|
      t.references :exercise, null: false, foreign_key: true, index: true
      t.references :muscle, null: false, foreign_key: true, index: true
      t.string :role

      t.timestamps
    end
    add_index :exercise_muscles, [ :exercise_id, :muscle_id, :role ], unique: true
  end
end
