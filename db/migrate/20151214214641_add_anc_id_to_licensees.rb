class AddAncIdToLicensees < ActiveRecord::Migration
  def change
    add_reference :licensees, :anc, index: true, foreign_key: true
  end
end
