class AddStatusToLicensees < ActiveRecord::Migration
  def change
    add_column :licensees, :status, :string
  end
end
