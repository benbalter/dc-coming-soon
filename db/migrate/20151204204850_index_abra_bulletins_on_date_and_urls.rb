class IndexAbraBulletinsOnDateAndUrls < ActiveRecord::Migration
  def change
    add_index :abra_bulletins, :date, :unique => true
    add_index :abra_bulletins, :pdf_url, :unique => true
    add_index :abra_bulletins, :html_url, :unique => true
  end
end
