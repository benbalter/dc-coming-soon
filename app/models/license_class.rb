class LicenseClass < ActiveRecord::Base
  validates_format_of :letter, :with => /\A[A-Z]{1,2}\z/
  validates_presence_of :name
  before_validation :ensure_letter

  REGEX = /([a-z]{3}ss|retailer’s)\s+“?([A-Z]{1,2})”?(\s+|$)/i

  private

  def ensure_letter
    puts "NAME: #{name.inspect}"
    self.letter = name.match(REGEX)[2].upcase
  end
end
