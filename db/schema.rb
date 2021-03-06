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

ActiveRecord::Schema.define(version: 20151221164815) do

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

  create_table "ancs", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "ward_id"
  end

  add_index "ancs", ["name"], name: "index_ancs_on_name", unique: true, using: :btree
  add_index "ancs", ["ward_id"], name: "index_ancs_on_ward_id", using: :btree

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
    t.integer "license_class_license_description_id"
    t.string  "status",                               limit: 255
    t.integer "anc_id"
    t.integer "license_id"
    t.integer "location_id"
  end

  add_index "licensees", ["anc_id"], name: "index_licensees_on_anc_id", using: :btree
  add_index "licensees", ["license_class_license_description_id"], name: "index_licensees_on_license_class_license_description_id", using: :btree
  add_index "licensees", ["location_id"], name: "index_licensees_on_location_id", using: :btree
  add_index "licensees", ["status"], name: "index_licensees_on_status", using: :btree

  create_table "location_postings", force: :cascade do |t|
    t.integer "location_id"
    t.integer "posting_id"
    t.string  "posting_type"
  end

  add_index "location_postings", ["location_id"], name: "index_location_postings_on_location_id", using: :btree
  add_index "location_postings", ["posting_type", "posting_id"], name: "index_location_postings_on_posting_type_and_posting_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer "street_number"
    t.string  "street_name"
    t.string  "street_type"
    t.string  "quad"
    t.decimal "lat"
    t.decimal "lng"
    t.string  "slug"
    t.integer "anc_id"
  end

  add_index "locations", ["anc_id"], name: "index_locations_on_anc_id", using: :btree
  add_index "locations", ["slug"], name: "index_locations_on_slug", unique: true, using: :btree

  create_table "postings", force: :cascade do |t|
    t.string  "type"
    t.string  "slug"
    t.date    "posting_date"
    t.date    "hearing_date"
    t.integer "pdf_page"
    t.integer "abra_bulletin_id"
    t.text    "details"
    t.text    "body"
    t.integer "licensee_id"
    t.string  "applicant"
    t.string  "raw_address"
    t.string  "number"
    t.string  "status"
    t.integer "location_id"
  end

  add_index "postings", ["abra_bulletin_id"], name: "index_postings_on_abra_bulletin_id", using: :btree
  add_index "postings", ["licensee_id"], name: "index_postings_on_licensee_id", using: :btree
  add_index "postings", ["location_id"], name: "index_postings_on_location_id", using: :btree
  add_index "postings", ["number"], name: "index_postings_on_number", using: :btree
  add_index "postings", ["slug"], name: "index_postings_on_slug", using: :btree
  add_index "postings", ["status"], name: "index_postings_on_status", using: :btree
  add_index "postings", ["type"], name: "index_postings_on_type", using: :btree

  create_table "wards", force: :cascade do |t|
  end

  create_table "zoning_commission_cases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ancs", "wards", on_delete: :cascade
  add_foreign_key "license_class_license_descriptions", "license_classes", on_delete: :cascade
  add_foreign_key "license_class_license_descriptions", "license_descriptions", on_delete: :cascade
  add_foreign_key "licensees", "ancs", on_delete: :cascade
  add_foreign_key "licensees", "license_class_license_descriptions", on_delete: :cascade
  add_foreign_key "licensees", "locations"
  add_foreign_key "location_postings", "locations"
  add_foreign_key "locations", "ancs"
  add_foreign_key "postings", "abra_bulletins"
  add_foreign_key "postings", "licensees"
  add_foreign_key "postings", "locations"
end
