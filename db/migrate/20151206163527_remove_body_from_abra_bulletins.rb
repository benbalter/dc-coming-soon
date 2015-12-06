class RemoveBodyFromAbraBulletins < ActiveRecord::Migration
  def change
    remove_column :abra_bulletins, :body
  end
end
