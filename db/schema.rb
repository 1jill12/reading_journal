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

ActiveRecord::Schema[8.1].define(version: 2026_03_22_000005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "action_type"
    t.datetime "created_at", null: false
    t.bigint "trackable_id", null: false
    t.string "trackable_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "az_challenge_entries", force: :cascade do |t|
    t.bigint "book_id"
    t.datetime "created_at", null: false
    t.string "custom_title"
    t.string "letter", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "year", null: false
    t.index ["book_id"], name: "index_az_challenge_entries_on_book_id"
    t.index ["user_id", "letter", "year"], name: "index_az_challenge_entries_on_user_id_and_letter_and_year", unique: true
  end

  create_table "bingo_cards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "theme"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "bingo_squares", force: :cascade do |t|
    t.bigint "bingo_card_id", null: false
    t.datetime "created_at", null: false
    t.boolean "free_space"
    t.integer "position"
    t.string "trope_name"
    t.datetime "updated_at", null: false
    t.index ["bingo_card_id"], name: "index_bingo_squares_on_bingo_card_id"
  end

  create_table "book_tropes", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.bigint "trope_id", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "trope_id"], name: "index_book_tropes_on_book_id_and_trope_id", unique: true
    t.index ["book_id"], name: "index_book_tropes_on_book_id"
    t.index ["trope_id"], name: "index_book_tropes_on_trope_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.string "cover_url"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "finished_at"
    t.string "format"
    t.string "genre"
    t.integer "humor_rating"
    t.integer "pages"
    t.integer "rating"
    t.integer "sadness_rating"
    t.integer "spice_rating"
    t.datetime "started_at"
    t.string "status"
    t.integer "suspense_rating"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "follower_id", null: false
    t.integer "following_id", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_follows_on_follower_id_and_following_id", unique: true
    t.index ["following_id"], name: "index_follows_on_following_id"
  end

  create_table "reading_goals", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.integer "current_progress", default: 0, null: false
    t.string "goal_type", null: false
    t.integer "month"
    t.string "status", default: "active", null: false
    t.integer "target", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "year"
    t.index ["user_id", "status"], name: "index_reading_goals_on_user_id_and_status"
    t.index ["user_id"], name: "index_reading_goals_on_user_id"
  end

  create_table "reflections", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reflections_on_book_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.float "rating"
    t.text "review_text"
    t.integer "spice_level"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_id", "book_id"], name: "index_reviews_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tropes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tropes_on_name", unique: true
  end

  create_table "user_bingo_cards", force: :cascade do |t|
    t.bigint "bingo_card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["bingo_card_id"], name: "index_user_bingo_cards_on_bingo_card_id"
    t.index ["user_id"], name: "index_user_bingo_cards_on_user_id"
  end

  create_table "user_bingo_squares", force: :cascade do |t|
    t.bigint "bingo_square_id", null: false
    t.bigint "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_bingo_card_id", null: false
    t.index ["bingo_square_id"], name: "index_user_bingo_squares_on_bingo_square_id"
    t.index ["book_id"], name: "index_user_bingo_squares_on_book_id"
    t.index ["user_bingo_card_id"], name: "index_user_bingo_squares_on_user_bingo_card_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "private_profile", default: false, null: false
    t.integer "reading_goal"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "theme", default: "neutral", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "activities", "users"
  add_foreign_key "bingo_squares", "bingo_cards"
  add_foreign_key "book_tropes", "books"
  add_foreign_key "book_tropes", "tropes"
  add_foreign_key "books", "users"
  add_foreign_key "reading_goals", "users"
  add_foreign_key "reflections", "books"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
  add_foreign_key "user_bingo_cards", "bingo_cards"
  add_foreign_key "user_bingo_cards", "users"
  add_foreign_key "user_bingo_squares", "bingo_squares"
  add_foreign_key "user_bingo_squares", "books"
  add_foreign_key "user_bingo_squares", "user_bingo_cards"
end
