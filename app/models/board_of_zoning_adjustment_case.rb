class BoardOfZoningAdjustmentCase < ZoningCase

  LOWEST_ID = 19140

  validates_format_of :number, with: /\d{5}/
  validates :hearing_date, date: true, allow_nil: true

  before_validation :ensure_hearing_date

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
        bza_case.save!
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
