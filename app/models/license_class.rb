class LicenseClass < ActiveRecord::Base

  CLASSES = %W[A B C CX D]

  validates_inclusion_of :letter, :in => CLASSES
  validates_uniqueness_of :letter

  has_many :licensees
  has_many :license_descriptions
end
