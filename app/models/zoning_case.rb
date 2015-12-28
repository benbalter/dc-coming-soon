require "#{Rails.root}/lib/mechanize/page/link"

class ZoningCase < Posting
  class InvalidCase < StandardError; end

  URL = "https://app.dcoz.dc.gov/Content/Search/Search.aspx"
  TYPES_ABBREVIATIONS = {
    "ZoningCommissionCase" => "ZC",
    "BoardOfZoningAdjustmentCase" => "BZA"
  }
  ABBREVIATIONS_TYPES = TYPES_ABBREVIATIONS.invert

  validates_uniqueness_of :number, scope: [:type]
  validates_presence_of :applicant, :raw_address, :number, :status

  before_validation :ensure_meta
  before_validation :ensure_applicant, prepend: true
  before_validation :ensure_location, prepend: true
  before_validation :ensure_address, prepend: true

  def exists?
    !!(page_body)
  end

  private

  def self.agent
    @agent ||= begin
      mech = Mechanize.new
      mech.agent.user_agent = Rails.application.config.user_agent
      mech
    end
  end

  def page_body
    @page_body ||= begin
      form = ZoningCase.agent.get(URL).form

      form.txtsearch = number
      page = ZoningCase.agent.submit(form, form.buttons.first)
      link = page.link_with id: 'ucPendingCases_dgOnlineCases_ctl03_lnkView'
      link.asp_click if link
    end
  end

  def key_value_pairs
    @key_value_pairs ||= begin
      rows = page_body.search(".hrGreen").first.parent.search("table").first.search("tr")
      rows = rows.select { |row| row.search("#pnlTable, #Label4").empty? }
      key_values = {}
      rows.each do |row|
        tds = row.search("td")
        key = tds[0].text.strip.sub(/\s*\:\z/, "")
        value = tds[1].text.strip
        key_values[key] = value
      end
      key_values
    end
  end

  def ensure_meta
    self.status    = key_value_pairs["Case Status"]
    self.body      = key_value_pairs["Case Description"]
  end

  def ensure_address
    return unless self.raw_address.nil?
    address = key_value_pairs["Property Address"]
    address = address.split("|").reject { |s| s.empty? }.first
    address = address.gsub(/\bwashington,? d\.?\.?c\z/i, "")
    raise InvalidCase if address.empty?
    self.raw_address = address
  end

  def ensure_location
    return unless self.location.nil?
    self.location = Location.find_or_create_by_address! self.raw_address
  end

  def ensure_applicant
    return unless self.applicant.nil? || self.applicant.empty?
    applicant = key_value_pairs["Applicant/Case Name"] || self.address
    raise InvalidCase if applicant.empty?
    self.applicant = applicant
  end
end
