class BoardOfZoningAdjustmentCase < ZoningCase

  LOWEST_ID = 19140

  validates_format_of :number, with: /\d{5}/
  before_validation :ensure_hearing_date

  def self.to_s
    "Board of Zoning Adjustment Case"
  end

  def self.model_name
    ZoningCase.model_name
  end

  def self.last_known_case_number
    if last_case = BoardOfZoningAdjustmentCase.all.order(:number).last
      last_case.number.to_i
    else
      LOWEST_ID
    end
  end

  def self.highest_case_number
    case_number = self.last_known_case_number

    # We need to look for case numbers by incrementing the last known case ID
    # But sometimes they skip case numbers. Track our consecutive misses to
    # know when we've actually retrieved the most recent case number
    misses = 0
    while misses <= 3
      case_number = case_number + 1
      bza_case = BoardOfZoningAdjustmentCase.new number: (case_number)
      if bza_case.exists?
        begin
          bza_case.save!
        rescue ZoningCase::InvalidCase, Location::InvalidAddress, DcAddressParser::Address::InvalidAddress
          Rails.logger.error "Failed to load BZA Case #{bza_case.number}"
        end
        misses = 0
      else
        misses = misses + 1
      end
    end
    self.last_known_case_number
  end

  private

  def ensure_hearing_date
    return unless self.hearing_date.nil?
    date = key_value_pairs["Hearing Date"]
    self.hearing_date = Date.strptime(date, '%m/%d/%Y') if date
  end
end
