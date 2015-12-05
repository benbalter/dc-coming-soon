class Licensee < ActiveRecord::Base
  has_many :abra_notices

  #validates_uniqueness_of :license_number
  validates_presence_of :name, :trade_name, :address

end
