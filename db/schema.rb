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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130816200024) do

  create_table "ballot_option_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
  end

  create_table "ballot_options", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
  end

  create_table "ballot_options_lunch_groups", :id => false, :force => true do |t|
    t.integer "ballot_option_id", :null => false
    t.integer "lunch_group_id",   :null => false
  end

  create_table "group_members", :force => true do |t|
    t.integer  "group_id"
    t.string   "email"
    t.string   "key_phrase"
    t.boolean  "is_admin",   :default => false
    t.boolean  "removed",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "group_members", ["group_id"], :name => "group_id"

  create_table "lunch_groups", :force => true do |t|
    t.string   "name"
    t.float    "loc_lat"
    t.float    "loc_lon"
    t.time     "polls_close_utc"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "prefs_json"
  end

  create_table "lunch_history", :force => true do |t|
    t.integer  "ballot_option_id"
    t.integer  "lunch_group_id"
    t.datetime "created_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "ballot_option_id"
    t.integer  "group_member_id"
    t.integer  "priority"
    t.boolean  "purged",           :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "votes", ["created_at"], :name => "created_at"

end
