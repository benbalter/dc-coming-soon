class LicenseClassLicenseDescription < ActiveRecord::Base
  belongs_to :license_class
  belongs_to :license_description

  validates :license_class_id, :license_description_id, numericality: true
  validates :license_class_id, uniqueness: { scope: :license_description_id }

  REGEX = /([a-z]{3}ss|retailer’s)\s+“?([A-Z]{1,2})”?(\s+|$)/i

  before_validation :ensure_license_class
  before_validation :ensure_license_description

  private

  def ensure_license_class
    self.license_class ||= begin
      letter = description.match(REGEX)[2].upcase
      LicenseClass.find_or_create_by letter: letter
    end
  end

  def ensure_license_description
    self.license_description ||= begin
      desc = description.match(REGEX)[3]
      LicenseDescription.find_or_create_by description: desc
    end
  end
end
