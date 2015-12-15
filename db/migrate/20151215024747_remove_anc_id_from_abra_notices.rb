class RemoveAncIdFromAbraNotices < ActiveRecord::Migration
  def change
    remove_column :abra_notices, :anc_id
  end
end
