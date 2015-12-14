class Licensee < ActiveRecord::Base
  has_many :abra_notices
  belongs_to :license_class_license_description

  has_one :license_class, through: :license_class_license_description
  has_one :license_description, through: :license_class_license_description

  before_validation :normalize_license_number
  before_validation :normalize_street_name
  before_validation :normalize_street_number
  before_validation :normalize_street_type
  before_validation :normalize_quad
  before_validation :ensure_lonlat

  validates_uniqueness_of :license_number
  validates_presence_of :applicant, :trade_name, :lon, :lat, :street_name
  validates_presence_of :street_type, :license_class_license_description_id, :status
  validates_format_of :license_number, :with => /ABRA-\d{6}/
  validates_numericality_of :street_number, only_integer: true,  message: "`%{value}` is not a valid street number."

  STATUSES     = ["Active", "Safekeeping", "405.1 New Const", "Pending"]
  QUADS        = %w[NW NE SW SE]
  STREET_TYPES = %w[ST AVE BLVD RD PL DR CIR PLZ CT AL]

  validates :quad, inclusion: { in: QUADS }
  validates :status, inclusion: { in: STATUSES, message: "`%{value}` is not a valid license status." }
  validates :street_type, inclusion: { in: STREET_TYPES, message: "`%{value}` is not a known street type." }

  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lon

  CITY = "WASHINGTON, DC"
  LICENSEE_LIST = "http://abra.dc.gov/page/abc-licensees"

  alias_attribute :name, :applicant

  class << self
    def latest_pdf
      # For some reason, the first response almost always returns no information
      response = Typhoeus.get LICENSEE_LIST, Rails.application.config.typhoeus_defaults
      response = Typhoeus.get LICENSEE_LIST, Rails.application.config.typhoeus_defaults
      return unless response.success?

      document = Nokogiri.HTML response.body
      link = document.css("article a").first.attr("href")
      link = URI.join "http://abra.dc.gov", link if link[0] = "/"

      response = Typhoeus.get link, Rails.application.config.typhoeus_defaults
      return unless response.success?
      document = Nokogiri.HTML response.body

      document.css(".file a").first.attr("href")
    end

    def parse_pdf
      pdf = Tempfile.new "abra-licensees-pdf"
      request = Typhoeus::Request.new latest_pdf, Rails.application.config.typhoeus_defaults
      request.on_body { |chunk| pdf.write(chunk.force_encoding("utf-8")) }
      request.on_complete { |response| pdf.close }
      request.run

      extractor = Tabula::Extraction::ObjectExtractor.new(pdf.path, :all )
      extractor.extract.each do |pdf_page|
        pdf_page.spreadsheets.each do |spreadsheet|
          rows = spreadsheet.to_a.drop(1)
          headings = rows.shift.map { |c| c.sub("\r","") }
          headings = headings.map { |h| h.sub("#","number").parameterize.underscore.to_sym }
          rows.each { |row| licensee_from_row(row, headings) }
        end
      end
    end

    def licensee_from_row(row, headings)
      attributes = {}
      row = row.map { |c| c.sub("\r","") }
      row.each_with_index do |cell, i|
        attributes[headings[i]] = cell.strip
      end

      licensee = Licensee.find_by :license_number => attributes[:license]
      return licensee if licensee

      license_class_license_description = LicenseClassLicenseDescription.find_or_create_by!({
        :license_class =>  LicenseClass.find_or_create_by!({ :letter => attributes[:class] }),
        :license_description => LicenseDescription.find_or_create_by!({
          :description => attributes[:description]
        })
      })

      Licensee.create!({
        :applicant                         => attributes[:applicant],
        :trade_name                        => attributes[:trade_name],
        :street_number                     => attributes[:street_number],
        :street_name                       => attributes[:street_name],
        :street_type                       => attributes[:type],
        :quad                              => attributes[:quad],
        :license_number                    => attributes[:license],
        :status                            => attributes[:status],
        :license_class_license_description => license_class_license_description
      })
    end
  end

  def address
    [street_number, street_name, street_type, "#{quad},", CITY].join(" ")
  end

  def address=(address)
    address = address.strip
    address = address.gsub(/([NS])\.([EW])\.?/, '\1\2')   # Normalize N.W. to NW
    address = address.gsub(/, ([NS][EW])/, ' \1')         # Remove comma before quad
    address = address.gsub(/\A(\d+)\s?(-|–)\s?\d+/, '\1') # Flatten ranges
    address = address.gsub(/\b(ave\w+)\b/i, "AVE")        # Normalize spelling of Avenue
    address = address.gsub(/,\sspace\s/i, "UNIT")          # Call a unit a unit
    address = "#{address}, #{CITY}"

    address = StreetAddress::US.parse address
    return unless address

    self.street_number = address.number
    self.street_name   = address.street
    self.street_type   = address.street_type
    self.quad          = address.suffix
  end

  private

  def ensure_lonlat
    return unless lon.nil? && lat.nil?
    options = { proximity: Rails.application.config.dc_centerpoint }
    response = Mapbox::Geocoder.geocode_forward address, options
    return unless response && !response.first["features"].empty?
    feature = response.first["features"].first
    self.lon = feature["center"][0]
    self.lat = feature["center"][1]
  end

  def normalize_license_number
    return unless self.license_number
    self.license_number = self.license_number.upcase.sub('‐','-')
  end

  def normalize_street_name
    return unless self.street_name

    # If this is a plain numeric street number, e.g., "14", ordinalize it for consistency (e.g., "14th")
    if self.street_name.to_i.to_s == self.street_name
      self.street_name = ActiveSupport::Inflector.ordinalize self.street_name
    end

    self.street_name = self.street_name.upcase
  end

  # Some street numbers are ranges. For simplicity, just use the first number in the range.
  # This allows us to store the column as integers, rather than strings, and simplifies geolocation
  # Oh, and did I mention they don't always use a standard hyphen?
  def normalize_street_number
    return unless self.street_number
    self.street_number = self.street_number.to_s.split(/-|‐/).first.to_i
  end

  def normalize_street_type
    return unless self.street_type
    self.street_type = self.street_type.upcase.sub("STREET", "ST").sub(/\W/, "")
  end

  def normalize_quad
    return unless self.quad
    self.quad = self.quad.upcase.gsub(".","")
  end
end
