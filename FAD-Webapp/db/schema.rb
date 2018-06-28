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

ActiveRecord::Schema.define(version: 2018_06_27_181248) do

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
    t.string "contains_other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_id"
    t.index ["menu_id"], name: "index_foods_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "menu_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id"
    t.string "menu_data", default: ""
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "address"
    t.string "cuisine"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
