class CreateAbraBulletins < ActiveRecord::Migration
  def change
    create_table :abra_bulletins do |t|
      t.string :pdf_url
      t.date :date

      t.timestamps null: false
    end
  end
end
