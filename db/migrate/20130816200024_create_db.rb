class CreateDb < ActiveRecord::Migration
  def up
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

  def down
  end
end
