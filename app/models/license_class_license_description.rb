class LicenseClassLicenseDescription < ActiveRecord::Base
  belongs_to :license_class
  belongs_to :license_description

  validates :license_class_id, :license_description_id, numericality: true
  validates :license_class_id, uniqueness: { scope: :license_description_id }

  REGEX = /([a-z]{3}ss|retailer’s)\s+“?([A-Z]{1,2})”?\s+?(.*)$/i

  def self.from_string(string)
    parts = string.match(REGEX)
    puts parts.inspect
    puts string.inspect
    letter = parts[2].upcase
    license_class = LicenseClass.find_or_create_by! letter: letter

    description = parts[3]
    license_description = LicenseDescription.find_or_create_by! description: description

    self.find_or_create_by! :license_class => license_class, :license_description => license_description
  end
end
