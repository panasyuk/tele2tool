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

ActiveRecord::Schema.define(version: 20131120021444) do

  create_table "groups", force: true do |t|
    t.string   "url"
    t.string   "screen_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gid"
  end

  add_index "groups", ["screen_name"], name: "index_groups_on_screen_name", unique: true, using: :btree

  create_table "posts", force: true do |t|
    t.integer  "vk_id"
    t.integer  "likes_count",    default: 0
    t.integer  "reposts_count",  default: 0
    t.integer  "comments_count", default: 0
    t.string   "type"
    t.integer  "author_id"
    t.text     "text"
    t.datetime "published_at"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["published_at", "group_id"], name: "index_posts_on_published_at_and_group_id", using: :btree
  add_index "posts", ["vk_id"], name: "index_posts_on_vk_id", unique: true, using: :btree

  create_table "reports", force: true do |t|
    t.integer  "likes_count",    default: 0
    t.integer  "reposts_count",  default: 0
    t.integer  "comments_count", default: 0
    t.date     "to_date"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "from_date"
  end

  add_index "reports", ["to_date", "group_id"], name: "index_reports_on_to_date_and_group_id", using: :btree

end
