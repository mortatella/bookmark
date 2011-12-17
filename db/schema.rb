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

ActiveRecord::Schema.define(:version => 20111215171056) do

  create_table "bookmarks", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookmarks_lists", :force => true do |t|
    t.integer  "bookmark_id"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks_lists", ["bookmark_id"], :name => "index_bookmarks_lists_on_bookmark_id"
  add_index "bookmarks_lists", ["list_id"], :name => "index_bookmarks_lists_on_list_id"

  create_table "bookmarks_tags", :force => true do |t|
    t.integer  "bookmark_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks_tags", ["bookmark_id"], :name => "index_bookmarks_tags_on_bookmark_id"
  add_index "bookmarks_tags", ["tag_id"], :name => "index_bookmarks_tags_on_tag_id"

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "public"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["user_id"], :name => "index_lists_on_user_id"

  create_table "manifests", :force => true do |t|
    t.integer  "bookmark_id"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manifests", ["bookmark_id"], :name => "index_manifests_on_bookmark_id"
  add_index "manifests", ["list_id"], :name => "index_manifests_on_list_id"

  create_table "shares", :force => true do |t|
    t.boolean  "write"
    t.integer  "list_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["list_id"], :name => "index_shares_on_list_id"
  add_index "shares", ["user_id"], :name => "index_shares_on_bookmark_id"

  create_table "tags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["title"], :name => "index_tags_on_title", :unique => true

  create_table "tags_users", :force => true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  add_index "tags_users", ["tag_id"], :name => "index_tags_users_on_tag_id"
  add_index "tags_users", ["user_id"], :name => "index_tags_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstName"
    t.string   "lastName"
    t.string   "username"
    t.integer  "default_list_id"
  end

  add_index "users", ["default_list_id"], :name => "index_users_on_default_list"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
