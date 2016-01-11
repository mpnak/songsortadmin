# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160111231312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "saved_station_tracks", force: true do |t|
    t.integer  "saved_station_id"
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saved_stations", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "station_id"
    t.integer  "undergroundness"
    t.boolean  "use_weather"
    t.boolean  "use_timeofday"
    t.boolean  "autoupdate"
  end

  create_table "songs", force: true do |t|
    t.integer  "station_id"
    t.string   "spotify_id"
    t.string   "name"
    t.string   "artist"
    t.integer  "undergroundness"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "taste_profile_id"
    t.boolean  "active",            default: false
    t.text     "short_description"
    t.string   "station_type",      default: "standard"
    t.string   "url"
    t.string   "station_art"
  end

  create_table "track_bans", force: true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "track_favorites", force: true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: true do |t|
    t.integer  "station_id"
    t.string   "spotify_id"
    t.string   "echo_nest_id"
    t.string   "title"
    t.string   "artist"
    t.integer  "undergroundness"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "echo_nest_song_id"
    t.text     "audio_summary"
    t.decimal  "energy"
    t.decimal  "valence"
  end

  create_table "user_station_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "station_id"
    t.text     "track_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_station_links", ["station_id"], name: "index_user_station_links_on_station_id", using: :btree
  add_index "user_station_links", ["user_id"], name: "index_user_station_links_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "auth_token"
  end

  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
