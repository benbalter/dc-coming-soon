class CreateLicensees < ActiveRecord::Migration
  def change
    create_table :licensees do |t|
      t.string :name
      t.string :trade_name
      t.string :address
    end
  end
end
