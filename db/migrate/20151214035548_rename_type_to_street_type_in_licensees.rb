class RenameTypeToStreetTypeInLicensees < ActiveRecord::Migration
  def change
    rename_column :licensees, :type, :street_type
  end
end
