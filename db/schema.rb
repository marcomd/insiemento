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

ActiveRecord::Schema.define(version: 2020_09_12_134345) do

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

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "firstname", limit: 30
    t.string "lastname", limit: 30
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
    t.integer "roles_mask"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["organization_id"], name: "index_admin_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attendees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "subscription_id", null: false
    t.bigint "organization_id", null: false
    t.boolean "presence"
    t.index ["course_event_id"], name: "index_attendees_on_course_event_id"
    t.index ["organization_id"], name: "index_attendees_on_organization_id"
    t.index ["subscription_id"], name: "index_attendees_on_subscription_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", limit: 60
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_categories_on_organization_id"
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
    t.bigint "organization_id", null: false
    t.bigint "category_id", null: false
    t.bigint "course_id", null: false
    t.bigint "room_id", null: false
    t.bigint "trainer_id"
    t.bigint "course_schedule_id", null: false
    t.datetime "event_date"
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "auditor_id"
    t.index ["category_id"], name: "index_course_events_on_category_id"
    t.index ["course_id"], name: "index_course_events_on_course_id"
    t.index ["course_schedule_id"], name: "index_course_events_on_course_schedule_id"
    t.index ["event_date"], name: "index_course_events_on_event_date"
    t.index ["organization_id"], name: "index_course_events_on_organization_id"
    t.index ["room_id"], name: "index_course_events_on_room_id"
    t.index ["state"], name: "index_course_events_on_state"
    t.index ["trainer_id"], name: "index_course_events_on_trainer_id"
  end

  create_table "course_schedules", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "category_id", null: false
    t.bigint "course_id", null: false
    t.bigint "room_id", null: false
    t.bigint "trainer_id"
    t.integer "event_day", limit: 2
    t.time "event_time"
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_course_schedules_on_category_id"
    t.index ["course_id"], name: "index_course_schedules_on_course_id"
    t.index ["organization_id"], name: "index_course_schedules_on_organization_id"
    t.index ["room_id"], name: "index_course_schedules_on_room_id"
    t.index ["trainer_id"], name: "index_course_schedules_on_trainer_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "category_id", null: false
    t.string "name", limit: 30
    t.text "description"
    t.integer "start_booking_hours", limit: 2
    t.integer "end_booking_minutes", limit: 2
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_courses_on_category_id"
    t.index ["organization_id"], name: "index_courses_on_organization_id"
  end

  create_table "order_products", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["organization_id"], name: "index_order_products_on_organization_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.integer "state", limit: 2, default: 10
    t.integer "total_amount_cents", default: 0
    t.integer "amount_to_pay_cents", default: 0
    t.integer "amount_paid_cents", default: 0
    t.integer "discount_cents", default: 0
    t.integer "currency", limit: 2, default: 0
    t.date "start_on"
    t.datetime "paid_at"
    t.bigint "approver_admin_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approver_admin_user_id"], name: "index_orders_on_approver_admin_user_id"
    t.index ["organization_id"], name: "index_orders_on_organization_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", limit: 60
    t.string "payoff", limit: 255
    t.string "email", limit: 100
    t.string "phone", limit: 15
    t.string "domain", limit: 100
    t.jsonb "theme", default: {}
    t.integer "state", limit: 2
    t.boolean "use_subscription", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "homepage_data", default: {}, null: false
    t.jsonb "homepage_features", default: [], null: false, array: true
    t.string "uuid", limit: 36
    t.jsonb "homepage_contacts", default: [], null: false, array: true
    t.jsonb "homepage_socials", default: [], null: false, array: true
    t.string "analytics_tag", limit: 32
    t.index ["domain"], name: "index_organizations_on_domain"
    t.index ["uuid"], name: "index_organizations_on_uuid"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id"
    t.bigint "order_id"
    t.integer "source", limit: 2
    t.integer "state", limit: 2, default: 10
    t.integer "amount_cents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "type", limit: 2
    t.json "external_service_response", default: {}
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["organization_id"], name: "index_payments_on_organization_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "category_id", null: false
    t.string "name", limit: 60
    t.string "description", limit: 255
    t.integer "price_cents"
    t.integer "days", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "product_type", limit: 2, null: false
    t.integer "state", limit: 2
    t.integer "max_accesses_number", limit: 2
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["organization_id"], name: "index_products_on_organization_id"
    t.index ["product_type"], name: "index_products_on_product_type"
    t.index ["state"], name: "index_products_on_state"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", limit: 30
    t.integer "max_attendees", limit: 2
    t.integer "state", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description", limit: 255
    t.index ["organization_id"], name: "index_rooms_on_organization_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "code", limit: 14
    t.bigint "organization_id", null: false
    t.bigint "category_id", null: false
    t.bigint "product_id", null: false
    t.bigint "user_id"
    t.bigint "order_id"
    t.date "start_on"
    t.date "end_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "subscription_type", limit: 2, null: false
    t.integer "state", limit: 2
    t.integer "max_accesses_number", limit: 2
    t.index ["category_id"], name: "index_subscriptions_on_category_id"
    t.index ["code"], name: "index_subscriptions_on_code", unique: true
    t.index ["order_id"], name: "index_subscriptions_on_order_id"
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
    t.index ["product_id"], name: "index_subscriptions_on_product_id"
    t.index ["start_on", "end_on"], name: "index_subscriptions_on_start_on_and_end_on"
    t.index ["state"], name: "index_subscriptions_on_state"
    t.index ["subscription_type"], name: "index_subscriptions_on_subscription_type"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "system_logs", force: :cascade do |t|
    t.bigint "organization_id"
    t.integer "log_level", limit: 2
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_system_logs_on_organization_id"
  end

  create_table "trainers", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "firstname", limit: 30
    t.string "lastname", limit: 30
    t.string "nickname", limit: 30
    t.text "bio"
    t.integer "state", limit: 2, default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_trainers_on_organization_id"
  end

  create_table "user_document_models", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.integer "state", limit: 2
    t.string "title", limit: 255
    t.text "body"
    t.integer "validity_days", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "recurring"
    t.index ["organization_id"], name: "index_user_document_models_on_organization_id"
    t.index ["state"], name: "index_user_document_models_on_state"
  end

  create_table "user_documents", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_document_model_id", null: false
    t.bigint "user_id", null: false
    t.integer "state", limit: 2
    t.string "title", limit: 255
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "expire_on"
    t.string "uuid", limit: 36
    t.string "sign_checksum", limit: 32
    t.index ["expire_on"], name: "index_user_documents_on_expire_on"
    t.index ["organization_id"], name: "index_user_documents_on_organization_id"
    t.index ["state"], name: "index_user_documents_on_state"
    t.index ["user_document_model_id"], name: "index_user_documents_on_user_document_model_id"
    t.index ["user_id"], name: "index_user_documents_on_user_id"
    t.index ["uuid"], name: "index_user_documents_on_uuid"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "organization_id", null: false
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
    t.date "medical_certificate_expire_at"
    t.bigint "trainer_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firstname"], name: "index_users_on_firstname"
    t.index ["lastname"], name: "index_users_on_lastname"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["trainer_id"], name: "index_users_on_trainer_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_users", "organizations"
  add_foreign_key "attendees", "course_events"
  add_foreign_key "attendees", "organizations"
  add_foreign_key "attendees", "subscriptions"
  add_foreign_key "attendees", "users"
  add_foreign_key "categories", "organizations"
  add_foreign_key "course_event_comments", "course_events"
  add_foreign_key "course_event_comments", "users"
  add_foreign_key "course_events", "categories"
  add_foreign_key "course_events", "course_schedules"
  add_foreign_key "course_events", "courses"
  add_foreign_key "course_events", "organizations"
  add_foreign_key "course_events", "rooms"
  add_foreign_key "course_events", "trainers"
  add_foreign_key "course_schedules", "categories"
  add_foreign_key "course_schedules", "courses"
  add_foreign_key "course_schedules", "organizations"
  add_foreign_key "course_schedules", "rooms"
  add_foreign_key "course_schedules", "trainers"
  add_foreign_key "courses", "categories"
  add_foreign_key "courses", "organizations"
  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "organizations"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "admin_users", column: "approver_admin_user_id"
  add_foreign_key "orders", "organizations"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "organizations"
  add_foreign_key "payments", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "organizations"
  add_foreign_key "rooms", "organizations"
  add_foreign_key "subscriptions", "categories"
  add_foreign_key "subscriptions", "orders"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "subscriptions", "products"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "system_logs", "organizations"
  add_foreign_key "trainers", "organizations"
  add_foreign_key "user_document_models", "organizations"
  add_foreign_key "user_documents", "organizations"
  add_foreign_key "user_documents", "user_document_models"
  add_foreign_key "user_documents", "users"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "trainers"
end
