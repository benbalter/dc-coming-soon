class MakeLicenseLetterNotUnique < ActiveRecord::Migration
  def change
    remove_index :license_classes, :letter
    add_index :license_classes, :letter
  end
end
