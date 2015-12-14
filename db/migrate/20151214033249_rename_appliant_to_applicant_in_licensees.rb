class RenameAppliantToApplicantInLicensees < ActiveRecord::Migration
  def change
    rename_column :licensees, :appliant, :applicant
  end
end
