class DropTimestampsFromAbraBulletin < ActiveRecord::Migration
  def change
    remove_column :abra_bulletins, :created_at
    remove_column :abra_bulletins, :updated_at
  end
end
