class AddHtmlUrlToAbraBulletins < ActiveRecord::Migration
  def change
    add_column :abra_bulletins, :html_url, :string
  end
end
