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

ActiveRecord::Schema.define(version: 20161118011628) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer  "channel_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_categories_on_channel_id", using: :btree
  end

  create_table "channels", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_invitations_on_chat_id", using: :btree
    t.index ["user_id"], name: "index_chat_invitations_on_user_id", using: :btree
  end

  create_table "chat_users", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_users_on_chat_id", using: :btree
    t.index ["user_id"], name: "index_chat_users_on_user_id", using: :btree
  end

  create_table "chats", force: :cascade do |t|
    t.string   "title"
    t.boolean  "group",      default: false
    t.integer  "admin_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "fcm_registrations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "registration_token"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["user_id"], name: "index_fcm_registrations_on_user_id", using: :btree
  end

  create_table "meme_tags", force: :cascade do |t|
    t.integer  "meme_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meme_id"], name: "index_meme_tags_on_meme_id", using: :btree
    t.index ["tag_id"], name: "index_meme_tags_on_tag_id", using: :btree
  end

  create_table "memes", force: :cascade do |t|
    t.integer  "owner_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.decimal  "rating",             default: "0.0"
    t.integer  "category_id"
    t.string   "name"
    t.index ["category_id"], name: "index_memes_on_category_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "chat_id"
    t.string   "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["chat_id"], name: "index_messages_on_chat_id", using: :btree
  end

  create_table "plain_memes", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "password_digest"
    t.string   "token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "categories", "channels"
  add_foreign_key "chat_invitations", "chats"
  add_foreign_key "chat_invitations", "users"
  add_foreign_key "chat_users", "chats"
  add_foreign_key "chat_users", "users"
  add_foreign_key "fcm_registrations", "users"
  add_foreign_key "meme_tags", "memes"
  add_foreign_key "meme_tags", "tags"
  add_foreign_key "memes", "categories"
  add_foreign_key "messages", "chats"
end
