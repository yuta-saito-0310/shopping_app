# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_10_29_080727) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shopping_details", force: :cascade do |t|
    t.string "item_name"
    t.integer "item_count"
    t.integer "item_price"
    t.bigint "shopping_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_name"], name: "index_shopping_details_on_item_name"
    t.index ["shopping_id"], name: "index_shopping_details_on_shopping_id"
  end

  create_table "shoppings", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_shoppings_on_name"
    t.index ["user_id"], name: "index_shoppings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "hashed_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "word_suggestions", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_word_suggestions_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_word_suggestions_on_user_id"
  end

  add_foreign_key "shopping_details", "shoppings"
  add_foreign_key "shoppings", "users"
  add_foreign_key "word_suggestions", "users"
end
