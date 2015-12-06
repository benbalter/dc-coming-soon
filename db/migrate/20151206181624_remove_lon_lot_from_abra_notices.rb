class RemoveLonLotFromAbraNotices < ActiveRecord::Migration
  def change
    remove_column :abra_notices, :lonlat
  end
end
