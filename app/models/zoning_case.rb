require "#{Rails.root}/lib/mechanize/page/link"

class ZoningCase < ActiveRecord::Base

  URL = "https://app.dcoz.dc.gov/Content/Search/Search.aspx"
  TYPES = {
    "ZC"  => "ZoningCommissionCase",
    "BZA" => "BoardOfZoningAdjustmentCase"
  }

  belongs_to :anc
  has_one :ward, through: :anc

  validates_inclusion_of :type, in: TYPES.values
  validates_uniqueness_of :number
  validates_presence_of :applicant, :address, :number
  validates_presence_of :status, :relief_type

  before_validation :ensure_meta
  before_validation :ensure_address
  before_validation :ensure_applicant
  before_validation :ensure_anc
  before_validation :ensure_lonlat

  def location
    @location ||= begin
      address = self.address.split(";").reject { |s| s.empty? }.first
      DcAddressLookup.lookup(address) unless address.match(/\A\d/).nil?
    rescue RestClient::InternalServerError
      nil
    end
  end

  def exists?
    !!(page_body)
  end

  private

  def self.agent
    @agent ||= begin
      mech = Mechanize.new
      mech.log = Rails.logger
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

  def ensure_anc
    return unless self.anc.nil?
    if key_value_pairs["ANC"]
      anc = key_value_pairs["ANC"].match Anc::REGEX
      self.anc = Anc.find_or_create_by! :name => anc[0] if anc
    else
      self.anc = Anc.find_or_create_by! :name => location.anc if location
    end
  end

  def ensure_meta
    self.applicant   = key_value_pairs["Applicant/Case Name"] if self.applicant.nil?
    self.status      = key_value_pairs["Case Status"] if self.status.nil?
    self.relief_type = key_value_pairs["Relief Type"] if self.relief_type.nil?
    self.description = key_value_pairs["Case Description"] if self.description.nil?
  end

  def ensure_address
    return unless self.address.nil?
    address = key_value_pairs["Property Address"].gsub(/\A(\d+)\s?(-|–|&)\s?\d+/, '\1')
    address = address.split("|").reject { |s| s.empty? }.first
    self.address = address
  end

  def ensure_applicant
    return unless self.applicant.nil? || self.applicant.empty?
    self.applicant = self.address
  end

  def ensure_lonlat
    return unless lon.nil? && lat.nil? && location && location.valid?
    self.lon = location.longitude
    self.lat = location.latitude
  end
end
