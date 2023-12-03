class CreateShoppings < ActiveRecord::Migration[7.1]
  def change
    create_table :shoppings do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :shoppings, :name
  end
end
