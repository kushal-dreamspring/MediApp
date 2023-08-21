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

ActiveRecord::Schema[7.0].define(version: 2023_04_29_185813) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.bigint "user_id", null: false
    t.datetime "date_time"
    t.decimal "amount", precision: 10, scale: 2
    t.jsonb "conversion_rates", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name", null: false
    t.string "image", null: false
    t.string "address", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.time "lunch_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "currency_preference", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointments", "doctors"
  add_foreign_key "appointments", "users"
end
