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

ActiveRecord::Schema.define(version: 20151205233403) do

  create_table "abra_bulletins", force: :cascade do |t|
    t.string "pdf_url"
    t.date   "date"
    t.string "html_url"
  end

  add_index "abra_bulletins", ["date"], name: "index_abra_bulletins_on_date", unique: true
  add_index "abra_bulletins", ["html_url"], name: "index_abra_bulletins_on_html_url", unique: true
  add_index "abra_bulletins", ["pdf_url"], name: "index_abra_bulletins_on_pdf_url", unique: true

  create_table "abra_notices", force: :cascade do |t|
    t.date    "posting_date"
    t.date    "petition_date"
    t.date    "hearing_date"
    t.date    "protest_date"
    t.integer "anc_id"
    t.integer "license_class_id"
    t.integer "pdf_page"
    t.integer "licensee_id"
    t.integer "license_number"
    t.integer "abra_bulletin_id"
  end

  add_index "abra_notices", ["abra_bulletin_id"], name: "index_abra_notices_on_abra_bulletin_id"
  add_index "abra_notices", ["anc_id"], name: "index_abra_notices_on_anc_id"
  add_index "abra_notices", ["license_class_id"], name: "index_abra_notices_on_license_class_id"
  add_index "abra_notices", ["licensee_id"], name: "index_abra_notices_on_licensee_id"

  create_table "ancs", force: :cascade do |t|
    t.string  "name"
    t.integer "ward_id"
  end

  add_index "ancs", ["name"], name: "index_ancs_on_name", unique: true
  add_index "ancs", ["ward_id"], name: "index_ancs_on_ward_id"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "license_classes", force: :cascade do |t|
    t.string "name"
    t.string "letter"
  end

  add_index "license_classes", ["letter"], name: "index_license_classes_on_letter"
  add_index "license_classes", ["name"], name: "index_license_classes_on_name", unique: true

  create_table "licensees", force: :cascade do |t|
    t.string "name"
    t.string "trade_name"
    t.string "address"
    t.string "license_number"
  end

  add_index "licensees", ["license_number"], name: "index_licensees_on_license_number"

  create_table "wards", force: :cascade do |t|
  end

end
