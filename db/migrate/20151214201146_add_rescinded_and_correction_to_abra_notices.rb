class AddRescindedAndCorrectionToAbraNotices < ActiveRecord::Migration
  def change
    add_column :abra_notices, :rescinded, :boolean
    add_column :abra_notices, :correction, :boolean
    add_index :abra_notices, :rescinded
    add_index :abra_notices, :correction
  end
end
