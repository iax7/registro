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

ActiveRecord::Schema.define(version: 20151106015609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.integer  "n1"
    t.integer  "n2"
    t.integer  "n3"
    t.integer  "option"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "allocations", ["person_id"], name: "index_allocations_on_person_id", using: :btree

  create_table "churches", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configs", force: :cascade do |t|
    t.integer  "foodcost"
    t.integer  "allocationcost"
    t.datetime "fooddeadline"
    t.datetime "allocationdeadline"
    t.integer  "max_food"
    t.integer  "max_allocation"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "iso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foodreals", force: :cascade do |t|
    t.integer  "v1",         default: 0
    t.integer  "v2",         default: 0
    t.integer  "v3",         default: 0
    t.integer  "s1",         default: 0
    t.integer  "s2",         default: 0
    t.integer  "s3",         default: 0
    t.integer  "d1",         default: 0
    t.integer  "d2",         default: 0
    t.integer  "d3",         default: 0
    t.integer  "l1",         default: 0
    t.integer  "l2",         default: 0
    t.integer  "l3",         default: 0
    t.integer  "v1c",        default: 0
    t.integer  "v2c",        default: 0
    t.integer  "v3c",        default: 0
    t.integer  "s1c",        default: 0
    t.integer  "s2c",        default: 0
    t.integer  "s3c",        default: 0
    t.integer  "d1c",        default: 0
    t.integer  "d2c",        default: 0
    t.integer  "d3c",        default: 0
    t.integer  "l1c",        default: 0
    t.integer  "l2c",        default: 0
    t.integer  "l3c",        default: 0
    t.integer  "person_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "foodreals", ["person_id"], name: "index_foodreals_on_person_id", using: :btree

  create_table "foods", force: :cascade do |t|
    t.integer  "v1"
    t.integer  "v2"
    t.integer  "v3"
    t.integer  "s1"
    t.integer  "s2"
    t.integer  "s3"
    t.integer  "d1"
    t.integer  "d2"
    t.integer  "d3"
    t.integer  "l1"
    t.integer  "l2"
    t.integer  "l3"
    t.integer  "v1c"
    t.integer  "v2c"
    t.integer  "v3c"
    t.integer  "s1c"
    t.integer  "s2c"
    t.integer  "s3c"
    t.integer  "d1c"
    t.integer  "d2c"
    t.integer  "d3c"
    t.integer  "l1c"
    t.integer  "l2c"
    t.integer  "l3c"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "foods", ["person_id"], name: "index_foods_on_person_id", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.integer  "age"
    t.boolean  "ismale"
    t.integer  "relation"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "guests", ["person_id"], name: "index_guests_on_person_id", using: :btree

  create_table "hotels", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.string   "cost"
    t.string   "url"
    t.string   "gmaps"
    t.string   "comments"
    t.boolean  "has_discount"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "nickname"
    t.string   "email"
    t.string   "phone"
    t.string   "church"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.integer  "age"
    t.string   "comments"
    t.boolean  "ismale"
    t.boolean  "isconfirmed"
    t.boolean  "ispresent"
    t.boolean  "isnotified"
    t.boolean  "iscancelled"
    t.boolean  "isadmin"
    t.string   "password"
    t.string   "salt"
    t.integer  "amount_paid"
    t.integer  "changed_by"
    t.boolean  "assist_v"
    t.boolean  "assist_s"
    t.boolean  "assist_d"
    t.boolean  "assist_l"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "author"
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "short"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towns", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "short"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transports", force: :cascade do |t|
    t.integer  "v1",         default: 0
    t.integer  "v2",         default: 0
    t.integer  "s1",         default: 0
    t.integer  "s2",         default: 0
    t.integer  "d1",         default: 0
    t.integer  "d2",         default: 0
    t.integer  "l1",         default: 0
    t.integer  "l2",         default: 0
    t.integer  "person_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "transports", ["person_id"], name: "index_transports_on_person_id", using: :btree

  add_foreign_key "allocations", "people"
  add_foreign_key "foodreals", "people"
  add_foreign_key "foods", "people"
  add_foreign_key "guests", "people"
  add_foreign_key "transports", "people"
end
