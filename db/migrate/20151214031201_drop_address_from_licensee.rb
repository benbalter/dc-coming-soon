class DropAddressFromLicensee < ActiveRecord::Migration
  def change
    remove_column :licensees, :address
  end
end
