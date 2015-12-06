class AddSlugToAbraNotice < ActiveRecord::Migration
  def change
    add_column :abra_notices, :slug, :string
    add_index :abra_notices, :slug, unique: true
  end
end
