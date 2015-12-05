class CreateAbraNotices < ActiveRecord::Migration
  def change
    create_table :abra_notices do |t|
      t.date :posting_date
      t.date :petition_date
      t.date :hearing_date
      t.date :protest_date
      t.references :anc, index: true, foreign_key: true
      t.references :license_class, index: true, foreign_key: true
    end
  end
end
