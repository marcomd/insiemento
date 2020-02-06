# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_01_223219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attendees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_event_id"], name: "index_attendees_on_course_event_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "course_event_comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_event_id", null: false
    t.string "message", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_event_id"], name: "index_course_event_comments_on_course_event_id"
    t.index ["user_id"], name: "index_course_event_comments_on_user_id"
  end

  create_table "course_events", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "room_id", null: false
    t.bigint "trainer_id", null: false
    t.bigint "course_schedule_id", null: false
    t.datetime "event_date"
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_events_on_course_id"
    t.index ["course_schedule_id"], name: "index_course_events_on_course_schedule_id"
    t.index ["room_id"], name: "index_course_events_on_room_id"
    t.index ["trainer_id"], name: "index_course_events_on_trainer_id"
  end

  create_table "course_schedules", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "room_id", null: false
    t.bigint "trainer_id", null: false
    t.integer "event_day", limit: 2
    t.time "event_time"
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_schedules_on_course_id"
    t.index ["room_id"], name: "index_course_schedules_on_room_id"
    t.index ["trainer_id"], name: "index_course_schedules_on_trainer_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", limit: 30
    t.text "description"
    t.integer "start_booking_hours", limit: 2
    t.integer "end_booking_minutes", limit: 2
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", limit: 30
    t.integer "max_attendees", limit: 2
    t.integer "state", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "system_logs", force: :cascade do |t|
    t.integer "log_level", limit: 2
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trainers", force: :cascade do |t|
    t.string "firstname", limit: 30
    t.string "lastname", limit: 30
    t.string "nickname", limit: 30
    t.text "bio"
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname", limit: 30
    t.string "lastname", limit: 30
    t.date "birthdate"
    t.string "gender", limit: 1
    t.integer "state", limit: 2, default: 10
    t.string "phone", limit: 15
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendees", "course_events"
  add_foreign_key "attendees", "users"
  add_foreign_key "course_event_comments", "course_events"
  add_foreign_key "course_event_comments", "users"
  add_foreign_key "course_events", "course_schedules"
  add_foreign_key "course_events", "courses"
  add_foreign_key "course_events", "rooms"
  add_foreign_key "course_events", "trainers"
  add_foreign_key "course_schedules", "courses"
  add_foreign_key "course_schedules", "rooms"
  add_foreign_key "course_schedules", "trainers"
end
