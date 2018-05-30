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

ActiveRecord::Schema.define(version: 2018_05_30_063915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "source"
    t.string "target"
    t.string "type"
  end

  create_table "messages", force: :cascade do |t|
    t.string "key"
    t.string "sig"
    t.string "author"
    t.integer "seq", default: 0
    t.string "previous"
    t.bigint "timestamp"
    t.bigint "localtime"
    t.string "type"
    t.text "raw"
    t.jsonb "content", default: "{}"
    t.integer "subposts_count", default: 0
    t.integer "votes_count", default: 0
    t.boolean "blocked", default: false
    t.string "channel"
    t.string "root"
    t.datetime "created_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "key"
    t.string "pubkey"
    t.string "prvkey"
    t.string "curve", default: "ed25519"
    t.integer "seq", default: 0
    t.string "previous"
    t.string "name"
    t.string "image"
    t.string "state", default: ""
    t.integer "messages_count", default: 0
    t.integer "posts_count", default: 0
    t.integer "subposts_count", default: 0
    t.integer "votes_count", default: 0
    t.integer "following_count", default: 0
    t.integer "general_following_count", default: 0
    t.boolean "is_blocking", default: false
    t.boolean "is_following", default: true
    t.datetime "created_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string "source"
    t.string "target"
  end

end
