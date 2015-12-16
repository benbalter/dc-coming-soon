class AddDetailsToAbraNotices < ActiveRecord::Migration
  def change
    add_column :abra_notices, :details, :text
    drop_table :details
  end
end
