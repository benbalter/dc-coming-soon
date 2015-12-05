class CreateAncs < ActiveRecord::Migration
  def change
    create_table :ancs do |t|
      t.string :name
      t.references :ward, index: true, foreign_key: true
    end
    add_index :ancs, :name, unique: true
  end
end
