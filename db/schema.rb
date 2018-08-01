# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_13_191458) do

  create_table "foods", force: :cascade do |t|
    t.boolean "contains_gluten"
    t.boolean "contains_dairy"
    t.boolean "contains_treenuts"
    t.boolean "contains_beef"
    t.boolean "contains_pork"
    t.boolean "contains_soy"
    t.boolean "contains_egg"
    t.boolean "contains_shellfish"
    t.boolean "contains_peanut"
    t.boolean "contains_fish"
    t.boolean "contains_sesame"
    t.boolean "contains_wheat"
    t.string "ingredients"
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id"
    t.index ["restaurant_id"], name: "index_foods_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.text "address"
    t.string "cuisine"
    t.text "description"
    t.boolean "scraped", default: false
    t.decimal "latitude", precision: 15, scale: 10, null: false
    t.decimal "longitude", precision: 15, scale: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "menu", default: ""
    t.boolean "admin_approved", default: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.boolean "gluten", default: false
    t.boolean "dairy", default: false
    t.boolean "treenuts", default: false
    t.boolean "beef", default: false
    t.boolean "pork", default: false
    t.boolean "soy", default: false
    t.boolean "egg", default: false
    t.boolean "shellfish", default: false
    t.boolean "peanut", default: false
    t.boolean "fish", default: false
    t.boolean "sesame", default: false
    t.boolean "wheat", default: false
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
