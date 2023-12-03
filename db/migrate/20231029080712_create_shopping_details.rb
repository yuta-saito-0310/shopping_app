class CreateShoppingDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_details do |t|
      t.string :item_name
      t.integer :item_count
      t.integer :item_price
      t.references :shopping, foreign_key: true

      t.timestamps
    end

    add_index :shopping_details, :item_name
  end
end
