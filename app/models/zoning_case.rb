require "#{Rails.root}/lib/mechanize/page/link"
class ZoningCase < ActiveRecord::Base
  class InvalidCase < StandardError; end
  class InvalidAddress < StandardError; end

  URL = "https://app.dcoz.dc.gov/Content/Search/Search.aspx"
  TYPES = {
    "ZC"  => "ZoningCommissionCase",
    "BZA" => "BoardOfZoningAdjustmentCase"
  }

  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lon

  belongs_to :anc
  has_one :ward, through: :anc

  validates_inclusion_of :type, in: TYPES.values
  validates_uniqueness_of :number
  validates_presence_of :applicant, :address, :number
  validates_presence_of :status, :relief_type, :location

  before_validation :ensure_meta
  before_validation :ensure_address
  before_validation :ensure_applicant
  before_validation :ensure_anc
  before_validation :ensure_lonlat

  def location
    @location ||= begin
      DcAddressLookup.lookup(address_for_geolocation) if address_for_geolocation
    rescue RestClient::InternalServerError
      nil
    end
  end

  def exists?
    !!(page_body)
  end

  def to_geojson
    {
      :type => "Feature",
      :properties => {
        :name       => applicant,
        :address    => address
      },
      :geometry => {
        :type => "Point",
        :coordinates => [
          lon,
          lat
        ]
      }
    }
  end

  private

  def address_for_geolocation
    return unless self.address
    @address_for_geolocation ||= begin
      Rails.logger.info "STARTING ADDRESS: #{self.address}"
      address = self.address.strip
      address = address.split(";").reject { |s| s.empty? }.first
      address = address.gsub(/\A(\d+)\s?(-|–|&)\s?\d+/, '\1')        # Flatten ranges
      address = address.gsub(/(\d+), \d+,? and \d+/i, '\1')
      address = address.split(/\band\b/i).first
      address = address.gsub(/([NS])\.([EW])\.?/, '\1\2')            # Normalize N.W. to NW
      address = address.gsub(/, ([NS][EW])/, ' \1')                  # Remove comma before quad
      address = address.split(/([NS][EW]),/)[0..1].join if address =~ /[NS][EW],/
      address = address.gsub(/\Arear of /i, '')
      address = address.gsub(/\A(\d+)[A-Z]/, '\1')
      address = address.strip.upcase
      Rails.logger.info "NORMALIZED ADDRESS: #{address}"
      raise InvalidAddress if address =~ /\bVA\b/
      raise InvalidAddress unless address =~ /\A\d/
      Rails.logger.info "ADDRESS FOR GEOLOCATION: #{address}"
      address
    end
  end

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
    address = key_value_pairs["Property Address"]
    address = address.split("|").reject { |s| s.empty? }.first
    address = address.gsub(/\bwashington,? d\.?\.?c\z/i, "")
    raise InvalidCase if address.empty?
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
