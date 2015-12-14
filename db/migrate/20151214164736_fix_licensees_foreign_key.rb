class FixLicenseesForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key :licensees, column: :license_class_license_description_id
    add_foreign_key :licensees, :license_class_license_descriptions
  end
end
