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

ActiveRecord::Schema.define(version: 20151215024747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abra_bulletins", force: :cascade do |t|
    t.string "pdf_url",  limit: 255
    t.date   "date"
    t.string "html_url", limit: 255
  end

  add_index "abra_bulletins", ["date"], name: "index_abra_bulletins_on_date", unique: true, using: :btree
  add_index "abra_bulletins", ["html_url"], name: "index_abra_bulletins_on_html_url", unique: true, using: :btree
  add_index "abra_bulletins", ["pdf_url"], name: "index_abra_bulletins_on_pdf_url", unique: true, using: :btree

  create_table "abra_notices", force: :cascade do |t|
    t.date    "posting_date"
    t.date    "petition_date"
    t.date    "hearing_date"
    t.date    "protest_date"
    t.integer "pdf_page"
    t.integer "licensee_id"
    t.integer "abra_bulletin_id"
    t.text    "body"
    t.string  "slug",             limit: 255
    t.boolean "rescinded"
    t.boolean "correction"
  end

  add_index "abra_notices", ["abra_bulletin_id"], name: "index_abra_notices_on_abra_bulletin_id", using: :btree
  add_index "abra_notices", ["correction"], name: "index_abra_notices_on_correction", using: :btree
  add_index "abra_notices", ["licensee_id"], name: "index_abra_notices_on_licensee_id", using: :btree
  add_index "abra_notices", ["rescinded"], name: "index_abra_notices_on_rescinded", using: :btree
  add_index "abra_notices", ["slug"], name: "index_abra_notices_on_slug", unique: true, using: :btree

  create_table "ancs", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "ward_id"
  end

  add_index "ancs", ["name"], name: "index_ancs_on_name", unique: true, using: :btree
  add_index "ancs", ["ward_id"], name: "index_ancs_on_ward_id", using: :btree

  create_table "details", force: :cascade do |t|
    t.string  "key",            limit: 255
    t.text    "value"
    t.integer "abra_notice_id"
  end

  add_index "details", ["abra_notice_id"], name: "index_details_on_abra_notice_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "license_class_license_descriptions", force: :cascade do |t|
    t.integer "license_class_id"
    t.integer "license_description_id"
  end

  add_index "license_class_license_descriptions", ["license_class_id"], name: "index_license_class_license_descriptions_on_license_class_id", using: :btree
  add_index "license_class_license_descriptions", ["license_description_id"], name: "index_license_class_license_descriptions_on_description_id", using: :btree

  create_table "license_classes", force: :cascade do |t|
    t.string "letter", limit: 255
  end

  add_index "license_classes", ["letter"], name: "index_license_classes_on_letter", unique: true, using: :btree

  create_table "license_descriptions", force: :cascade do |t|
    t.string "description"
  end

  add_index "license_descriptions", ["description"], name: "index_license_descriptions_on_description", unique: true, using: :btree

  create_table "licensees", force: :cascade do |t|
    t.string  "applicant",                            limit: 255
    t.string  "trade_name",                           limit: 255
    t.decimal "lat",                                              precision: 15, scale: 10
    t.decimal "lon",                                              precision: 15, scale: 10
    t.integer "license_class_license_description_id"
    t.integer "street_number"
    t.string  "street_name",                          limit: 255
    t.string  "street_type",                          limit: 255
    t.string  "quad",                                 limit: 255
    t.string  "status",                               limit: 255
    t.integer "anc_id"
    t.integer "license_id"
  end

  add_index "licensees", ["anc_id"], name: "index_licensees_on_anc_id", using: :btree
  add_index "licensees", ["lat"], name: "index_licensees_on_lat", using: :btree
  add_index "licensees", ["license_class_license_description_id"], name: "index_licensees_on_license_class_license_description_id", using: :btree
  add_index "licensees", ["lon"], name: "index_licensees_on_lon", using: :btree
  add_index "licensees", ["status"], name: "index_licensees_on_status", using: :btree

  create_table "wards", force: :cascade do |t|
  end

  add_foreign_key "abra_notices", "abra_bulletins"
  add_foreign_key "abra_notices", "licensees"
  add_foreign_key "ancs", "wards"
  add_foreign_key "details", "abra_notices"
  add_foreign_key "license_class_license_descriptions", "license_classes"
  add_foreign_key "license_class_license_descriptions", "license_descriptions"
  add_foreign_key "licensees", "ancs"
  add_foreign_key "licensees", "license_class_license_descriptions"
end
