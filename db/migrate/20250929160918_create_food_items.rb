class CreateFoodItems < ActiveRecord::Migration[8.0]
  def change
    create_table :food_items do |t|
      t.string :name
      t.integer :category
      t.date :expiration_date
      t.references :room, null: false, foreign_key: true
      t.references :registered_by, null: false, foreign_key: { to_table: :users }
      t.references :used_by, null: true, foreign_key: { to_table: :users }
      t.text :restriction_tags
      t.text :memo

      t.timestamps
    end
  end
end
