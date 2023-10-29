class CreateShoppingDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_details do |t|
      t.string :item_name
      t.integer :sum, limit: 4
      t.references :shopping, foreign_key: true

      t.timestamps
    end

    add_index :shopping_details, :item_name
  end
end
