class AddAbraBulletintoAbraNotices < ActiveRecord::Migration
  def change
    add_reference :abra_notices, :abra_bulletin, index: true, foreign_key: true
  end
end
