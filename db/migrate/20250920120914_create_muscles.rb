class CreateMuscles < ActiveRecord::Migration[8.0]
  def change
    create_table :muscles do |t|
      t.string :name

      t.timestamps
    end
    add_index :muscles, :name
  end
end
