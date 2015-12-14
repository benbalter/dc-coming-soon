class LicenseClassLicenseDescription < ActiveRecord::Base
  belongs_to :license_class
  belongs_to :license_description

  validates :license_class_id, :license_description_id, numericality: true
  validates :license_class_id, uniqueness: { scope: :license_description_id }

  REGEX = /\A(Retailer’s Class|[a-z]{3}ss|retailer’s)\s+“?([A-Z]{1,2}?)”?\s?(.*)\z/i

  def self.from_string(string)
    parts = string.strip.match(REGEX)
    return unless parts
    
    letter = parts[2].upcase
    license_class = LicenseClass.find_or_create_by! letter: letter

    if parts[1] == "Retailer’s Class"
      description = "Retail ‐ Class #{letter}"
    else
      description = parts[3]
    end
    license_description = LicenseDescription.find_or_create_by! description: description

    self.find_or_create_by! :license_class => license_class, :license_description => license_description
  end
end
