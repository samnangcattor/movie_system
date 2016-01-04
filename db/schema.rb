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

ActiveRecord::Schema.define(version: 20160104091711) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "coming_soon_movies", force: :cascade do |t|
    t.text     "photo",      limit: 65535
    t.text     "link",       limit: 65535
    t.string   "title",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.text     "message",             limit: 65535
    t.text     "referrer",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "links", force: :cascade do |t|
    t.integer  "movie_id",    limit: 4
    t.string   "link_title",  limit: 255
    t.text     "url_default", limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "status_link",               default: false
    t.text     "url_hd",      limit: 65535
  end

  add_index "links", ["movie_id"], name: "index_links_on_movie_id", using: :btree

  create_table "movie_categories", force: :cascade do |t|
    t.integer  "movie_id",    limit: 4
    t.integer  "category_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "movie_categories", ["category_id"], name: "index_movie_categories_on_category_id", using: :btree
  add_index "movie_categories", ["movie_id"], name: "index_movie_categories_on_movie_id", using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title",       limit: 255,   default: "Default Movie"
    t.text     "description", limit: 65535
    t.text     "link_movie",  limit: 65535
    t.text     "link_cover",  limit: 65535
    t.integer  "year_id",     limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.text     "photo",       limit: 65535
    t.boolean  "suggestion",                default: false
    t.integer  "quality",     limit: 4,     default: 0
    t.boolean  "slide",                     default: false
    t.boolean  "cinema",                    default: false
  end

  add_index "movies", ["year_id"], name: "index_movies_on_year_id", using: :btree

  create_table "po_pular_movies", force: :cascade do |t|
    t.text     "photo",      limit: 65535
    t.text     "link",       limit: 65535
    t.string   "title",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "request_movies", force: :cascade do |t|
    t.text     "photo",      limit: 65535
    t.text     "link",       limit: 65535
    t.string   "title",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255, default: "Default User"
    t.string   "email",                  limit: 255, default: "",             null: false
    t.string   "encrypted_password",     limit: 255, default: "",             null: false
    t.string   "avatar",                 limit: 255
    t.integer  "role",                   limit: 4
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,              null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "years", force: :cascade do |t|
    t.integer  "number",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
