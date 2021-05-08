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

ActiveRecord::Schema.define(version: 2021_05_08_162105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.integer "discogs_artist_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discogs_artist_id"], name: "index_artists_on_discogs_artist_id", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.integer "followable_id"
    t.string "followable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "label_id"
    t.bigint "user_id"
    t.bigint "artist_id"
    t.index ["artist_id"], name: "index_follows_on_artist_id"
    t.index ["label_id"], name: "index_follows_on_label_id"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "labels", force: :cascade do |t|
    t.integer "discogs_label_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discogs_label_id"], name: "index_labels_on_discogs_label_id", unique: true
  end

  create_table "releases", force: :cascade do |t|
    t.integer "discogs_release_id"
    t.string "title"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "artist_id"
    t.string "thumb"
    t.bigint "label_id"
    t.index ["artist_id"], name: "index_releases_on_artist_id"
    t.index ["discogs_release_id", "label_id"], name: "index_releases_on_discogs_release_id_and_label_id", unique: true
    t.index ["label_id"], name: "index_releases_on_label_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "follows", "artists"
  add_foreign_key "follows", "labels"
  add_foreign_key "follows", "users"
  add_foreign_key "releases", "artists"
end
