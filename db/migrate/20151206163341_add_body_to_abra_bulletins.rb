class AddBodyToAbraBulletins < ActiveRecord::Migration
  def change
    add_column :abra_bulletins, :body, :text
  end
end
