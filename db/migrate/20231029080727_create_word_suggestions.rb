class CreateWordSuggestions < ActiveRecord::Migration[7.1]
  def change
    create_table :word_suggestions do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_index :word_suggestions, [:name, :user_id], unique: true
  end

end
