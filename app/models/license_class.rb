class LicenseClass < ActiveRecord::Base
  validates_format_of :letter, :with => /\A[A-Z]{1,2}\z/
  validates_uniqueness_of :letter

  has_many :licensees
  has_many :license_descriptions
end
