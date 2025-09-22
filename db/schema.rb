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

ActiveRecord::Schema[8.0].define(version: 2025_09_22_034554) do
  create_table "exercise_muscles", force: :cascade do |t|
    t.integer "exercise_id", null: false
    t.integer "muscle_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id", "muscle_id", "role"], name: "index_exercise_muscles_on_exercise_id_and_muscle_id_and_role", unique: true
    t.index ["exercise_id"], name: "index_exercise_muscles_on_exercise_id"
    t.index ["muscle_id"], name: "index_exercise_muscles_on_muscle_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_exercises_on_name"
  end

  create_table "muscles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_muscles_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workout_day_items", force: :cascade do |t|
    t.integer "workout_day_id", null: false
    t.integer "exercise_id", null: false
    t.integer "order"
    t.integer "superset_group"
    t.integer "planned_sets"
    t.integer "planned_reps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_workout_day_items_on_exercise_id"
    t.index ["workout_day_id"], name: "index_workout_day_items_on_workout_day_id"
  end

  create_table "workout_days", force: :cascade do |t|
    t.integer "workout_plan_id", null: false
    t.string "name"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_plan_id"], name: "index_workout_days_on_workout_plan_id"
  end

  create_table "workout_plans", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.boolean "is_template", default: false, null: false
    t.boolean "is_published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workout_plans_on_user_id"
  end

  add_foreign_key "exercise_muscles", "exercises"
  add_foreign_key "exercise_muscles", "muscles"
  add_foreign_key "workout_day_items", "exercises"
  add_foreign_key "workout_day_items", "workout_days"
  add_foreign_key "workout_days", "workout_plans"
  add_foreign_key "workout_plans", "users"
end
