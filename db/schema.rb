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

ActiveRecord::Schema.define(version: 20150109113241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "found", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "animal_type"
    t.string   "animal_breed"
    t.string   "animal_gender"
    t.string   "comment"
    t.boolean  "is_found"
    t.datetime "date_found"
    t.string   "where_found"
    t.decimal  "where_longitude"
    t.decimal  "where_latitude"
    t.string   "chip_manufacturer"
    t.string   "chip_id"
    t.string   "other"
    t.datetime "created"
  end

  create_table "found_images", force: :cascade do |t|
    t.integer "animal_id"
    t.string  "image_url"
  end

  create_table "found_messages", force: :cascade do |t|
    t.integer  "animal_id"
    t.string   "message"
    t.string   "last_location"
    t.decimal  "last_longitude"
    t.decimal  "last_latitude"
    t.datetime "created"
  end

  create_table "lost", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "animal_type"
    t.string   "animal_breed"
    t.string   "animal_gender"
    t.string   "comment"
    t.boolean  "is_lost"
    t.datetime "date_lost"
    t.string   "where_lost"
    t.decimal  "where_longitude"
    t.decimal  "where_latitude"
    t.string   "chip_manufacturer"
    t.string   "chip_id"
    t.string   "other"
    t.datetime "created"
  end

  create_table "lost_images", force: :cascade do |t|
    t.integer "animal_id"
    t.string  "image_url"
  end

  create_table "lost_messages", force: :cascade do |t|
    t.integer  "animal_id"
    t.string   "message"
    t.string   "last_location"
    t.decimal  "last_longitude"
    t.decimal  "last_latitude"
    t.datetime "created"
  end

  create_table "users", force: :cascade do |t|
    t.string  "email_address"
    t.string  "password"
    t.string  "street_address"
    t.string  "city"
    t.string  "state"
    t.string  "zipcode"
    t.decimal "longitude"
    t.decimal "latitude"
    t.string  "phone_home"
    t.string  "phone_cell"
    t.string  "fb_account"
    t.string  "fb_token"
    t.integer "activation"
  end

  add_foreign_key "found", "users", name: "found_user_id_fkey"
  add_foreign_key "found_images", "found", column: "animal_id", name: "found_images_animal_id_fkey"
  add_foreign_key "found_messages", "found", column: "animal_id", name: "found_messages_animal_id_fkey"
  add_foreign_key "lost", "users", name: "lost_user_id_fkey"
  add_foreign_key "lost_images", "lost", column: "animal_id", name: "lost_images_animal_id_fkey"
  add_foreign_key "lost_messages", "lost", column: "animal_id", name: "lost_messages_animal_id_fkey"
end
