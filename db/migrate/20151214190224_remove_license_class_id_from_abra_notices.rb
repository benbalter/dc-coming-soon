class RemoveLicenseClassIdFromAbraNotices < ActiveRecord::Migration
  def change
    remove_column :abra_notices, :license_class_id
  end
end
