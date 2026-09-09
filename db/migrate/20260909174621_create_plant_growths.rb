class CreatePlantGrowths < ActiveRecord::Migration[8.0]
  def change
    create_table :plant_growths do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :level, default: 1, null: false
      t.integer :experience_point, default: 0, null: false
      t.integer :fruit_count, default: 0, null: false

      t.timestamps
    end
  end
end
