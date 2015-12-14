class RenameNameToApplicantInLicenees < ActiveRecord::Migration
  def change
    rename_column :licensees, :name, :appliant
  end
end
