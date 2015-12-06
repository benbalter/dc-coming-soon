class RemoveLonLatFromLicensees < ActiveRecord::Migration
  def change
    remove_column :licensees, :lonlat
  end
end
