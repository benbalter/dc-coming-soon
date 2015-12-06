class AddLonLatToLicensees < ActiveRecord::Migration
  def change
    add_column :licensees, :lonlat, :st_point
  end
end
