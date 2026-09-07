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

ActiveRecord::Schema[8.1].define(version: 2026_09_07_182629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "action_type", null: false
    t.datetime "created_at", null: false
    t.text "message", null: false
    t.boolean "read_status", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "stock_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "stock_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_tags_on_stock_id"
    t.index ["tag_id"], name: "index_stock_tags_on_tag_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.decimal "acquisition_price", default: "0.0"
    t.datetime "created_at", null: false
    t.text "exit_scenario", null: false
    t.text "fomo_advice"
    t.integer "fomo_score"
    t.bigint "group_id"
    t.string "name", null: false
    t.text "purchase_motivation", null: false
    t.decimal "shares", default: "0.0"
    t.integer "status", default: 0, null: false
    t.string "ticker_symbol", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["group_id"], name: "index_stocks_on_group_id"
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.text "investment_policy"
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "groups", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "stock_tags", "stocks"
  add_foreign_key "stock_tags", "tags"
  add_foreign_key "stocks", "groups"
  add_foreign_key "stocks", "users"
end
