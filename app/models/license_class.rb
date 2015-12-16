class LicenseClass < ActiveRecord::Base

  has_many :license_class_license_descriptions, dependent: :destroy

  CLASSES = %W[A B C CX D]

  validates_inclusion_of :letter, :in => CLASSES
  validates_uniqueness_of :letter

  has_many :licensees
  has_many :license_descriptions
end
