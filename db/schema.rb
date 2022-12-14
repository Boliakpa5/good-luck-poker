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

ActiveRecord::Schema[7.0].define(version: 2022_12_08_093033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "player_hands", force: :cascade do |t|
    t.string "player_card1"
    t.string "player_card2"
    t.bigint "player_id", null: false
    t.bigint "table_hand_id", null: false
    t.integer "bet_amount", default: 0
    t.boolean "folded", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "winner", default: false
    t.integer "combination", array: true
    t.index ["player_id"], name: "index_player_hands_on_player_id"
    t.index ["table_hand_id"], name: "index_player_hands_on_table_hand_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "poker_table_id", null: false
    t.integer "stack"
    t.integer "position"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poker_table_id"], name: "index_players_on_poker_table_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "poker_tables", force: :cascade do |t|
    t.string "name"
    t.integer "max_players"
    t.integer "small_blind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "table_hands", force: :cascade do |t|
    t.bigint "poker_table_id", null: false
    t.string "table_card1"
    t.string "table_card2"
    t.string "table_card3"
    t.string "table_card4"
    t.string "table_card5"
    t.integer "first_player_position"
    t.integer "current_player_position"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_call_amount"
    t.integer "positions", array: true
    t.integer "counter", default: 0
    t.integer "pot", default: 0
    t.index ["poker_table_id"], name: "index_table_hands_on_poker_table_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.integer "balance", default: 500
    t.float "luck_ratio"
    t.float "daily_ratio"
    t.boolean "increasing_luck", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "player_hands", "players"
  add_foreign_key "player_hands", "table_hands"
  add_foreign_key "players", "poker_tables"
  add_foreign_key "players", "users"
  add_foreign_key "table_hands", "poker_tables"
end
