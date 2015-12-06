class AddLonLatToAbraNotices < ActiveRecord::Migration
  def change
    add_column :abra_notices, :lonlat, :st_point, :geographic => true
  end
end
