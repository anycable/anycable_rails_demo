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

ActiveRecord::Schema.define(version: 2020_05_04_092152) do

  create_table "items", force: :cascade do |t|
    t.integer "list_id", null: false
    t.text "desc", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_items_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name", null: false
    t.integer "workspace_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["workspace_id"], name: "index_lists_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name", null: false
    t.string "public_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_workspaces_on_public_id"
  end

  add_foreign_key "items", "lists"
  add_foreign_key "lists", "workspaces"
end
