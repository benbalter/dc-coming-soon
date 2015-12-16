class LicenseDescription < ActiveRecord::Base
  has_many :license_class_license_descriptions, dependent: :destroy

  validates_uniqueness_of :description
  validates_presence_of :description

  before_validation :normalize_description
  has_one :license_class

  private

  def normalize_description
    self.description = self.description.strip
  end
end
