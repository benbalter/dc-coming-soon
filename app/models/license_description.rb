class LicenseDescription < ActiveRecord::Base
  validates_uniqueness_of :description
  has_one :license_class
end
