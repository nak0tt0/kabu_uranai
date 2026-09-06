class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, foreign_key: true # Nullable
      t.string :ticker_symbol, null: false
      t.string :name, null: false
      t.integer :status, default: 0, null: false # 0: holding, 1: pending, 2: sold
      t.decimal :shares, default: 0
      t.decimal :acquisition_price, default: 0
      t.text :purchase_motivation, null: false
      t.text :exit_scenario, null: false
      t.integer :fomo_score
      t.text :fomo_advice

      t.timestamps
    end
  end
end
