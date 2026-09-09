class CreatePostMortems < ActiveRecord::Migration[8.0]
  def change
    create_table :post_mortems do |t|
      t.references :stock, null: false, foreign_key: true
      t.decimal :sold_price, precision: 10, scale: 2
      t.datetime :sold_at
      t.text :exit_reason
      t.text :ai_review_comment
      t.boolean :rule_followed, default: true

      t.timestamps
    end
  end
end
