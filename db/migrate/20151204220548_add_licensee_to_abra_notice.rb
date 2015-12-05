class AddLicenseeToAbraNotice < ActiveRecord::Migration
  def change
    add_reference :abra_notices, :licensee, index: true, foreign_key: true
  end
end
