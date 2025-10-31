# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_10_31_170353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "settings", default: {}, null: false
    t.jsonb "statistics", default: {}, null: false
    t.index ["settings"], name: "index_events_on_settings", using: :gin
  end

  create_table "guests", force: :cascade do |t|
    t.bigint "registry_id"
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "nick", null: false
    t.boolean "is_male", null: false
    t.integer "age", null: false
    t.integer "relation"
    t.boolean "is_pregnant", default: false, null: false
    t.boolean "is_medicated", default: false, null: false
    t.boolean "f_v1", default: false, null: false
    t.boolean "f_v2", default: false, null: false
    t.boolean "f_v3", default: false, null: false
    t.boolean "f_s1", default: false, null: false
    t.boolean "f_s2", default: false, null: false
    t.boolean "f_s3", default: false, null: false
    t.boolean "f_d1", default: false, null: false
    t.boolean "f_d2", default: false, null: false
    t.boolean "f_d3", default: false, null: false
    t.boolean "f_l1", default: false, null: false
    t.boolean "f_l2", default: false, null: false
    t.boolean "f_l3", default: false, null: false
    t.boolean "t_v1", default: false, null: false
    t.boolean "t_v2", default: false, null: false
    t.boolean "t_s1", default: false, null: false
    t.boolean "t_s2", default: false, null: false
    t.boolean "t_d1", default: false, null: false
    t.boolean "t_d2", default: false, null: false
    t.boolean "t_l1", default: false, null: false
    t.boolean "t_l2", default: false, null: false
    t.boolean "l_v", default: false, null: false
    t.boolean "l_s", default: false, null: false
    t.boolean "l_d", default: false, null: false
    t.boolean "l_l", default: false, null: false
    t.string "l_room"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "fu_v1", default: 0, null: false
    t.integer "fu_v2", default: 0, null: false
    t.integer "fu_v3", default: 0, null: false
    t.integer "fu_s1", default: 0, null: false
    t.integer "fu_s2", default: 0, null: false
    t.integer "fu_s3", default: 0, null: false
    t.integer "fu_d1", default: 0, null: false
    t.integer "fu_d2", default: 0, null: false
    t.integer "fu_d3", default: 0, null: false
    t.integer "fu_l1", default: 0, null: false
    t.integer "fu_l2", default: 0, null: false
    t.integer "fu_l3", default: 0, null: false
    t.integer "tu_v1", default: 0, null: false
    t.integer "tu_v2", default: 0, null: false
    t.integer "tu_s1", default: 0, null: false
    t.integer "tu_s2", default: 0, null: false
    t.integer "tu_d1", default: 0, null: false
    t.integer "tu_d2", default: 0, null: false
    t.integer "tu_l1", default: 0, null: false
    t.integer "tu_l2", default: 0, null: false
    t.integer "lu_v", default: 0, null: false
    t.integer "lu_s", default: 0, null: false
    t.integer "lu_d", default: 0, null: false
    t.integer "lu_l", default: 0, null: false
    t.index ["registry_id"], name: "index_guests_on_registry_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "registry_id"
    t.bigint "user_id"
    t.integer "amount", null: false
    t.integer "kind", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["registry_id"], name: "index_payments_on_registry_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "registries", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "event_id"
    t.text "comments"
    t.boolean "is_confirmed", default: false, null: false
    t.boolean "is_present", default: false, null: false
    t.boolean "is_notified", default: false, null: false
    t.integer "amount_debt", default: 0
    t.integer "amount_paid", default: 0
    t.integer "amount_offering", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "paid_by"
    t.index ["event_id"], name: "index_registries_on_event_id"
    t.index ["user_id"], name: "index_registries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.string "nick"
    t.boolean "is_male", default: true, null: false
    t.date "dob"
    t.string "email", null: false
    t.string "phone"
    t.boolean "is_admin", default: false
    t.string "password_digest"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country"
    t.string "state"
    t.string "city"
    t.jsonb "guest_history", default: [], null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["lastname"], name: "index_users_on_lastname"
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "guests", "registries"
  add_foreign_key "payments", "registries"
  add_foreign_key "payments", "users"
  add_foreign_key "registries", "events"
  add_foreign_key "registries", "users"
end
