class RemoveTimestampsFromDetail < ActiveRecord::Migration
  def change
    remove_column :details, :created_at
    remove_column :details, :updated_at
  end
end
