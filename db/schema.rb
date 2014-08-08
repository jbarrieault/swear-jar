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

ActiveRecord::Schema.define(version: 20140808165028) do

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
    t.boolean  "active",     default: true
    t.integer  "balance",    default: 0
    t.boolean  "refunded",   default: false
  end

  create_table "trigger_violations", force: true do |t|
    t.integer  "trigger_id"
    t.integer  "violation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "triggers", force: true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.string   "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "twitter_id"
    t.integer  "venmo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.integer  "bookend"
    t.string   "encrypted_token"
  end

  create_table "violations", force: true do |t|
    t.integer  "tweet_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
