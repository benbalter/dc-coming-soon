class Location < ActiveRecord::Base
  class InvalidAddress < StandardError; end

  QUADS            = %w[NW NE SW SE]
  STREET_TYPES     = {
    street:    "ST",
    avenue:    "AVE",
    boulevard: "BLVD",
    road:      "RD",
    place:     "PL",
    drive:     "DR",
    circle:    "CIR",
    plaza:     "PLZ",
    court:     "CT",
    alley:     "AL",
    terrace:   "TER"
  }
  DIRECTIONS      = {
    north:     "N",
    south:     "S",
    east:      "E",
    west:      "W"
  }
  STREET_TYPES_ABV = STREET_TYPES.invert
  STREET_TYPES_REGEX = /\b(#{STREET_TYPES.keys.join("|")})\b/i

  belongs_to :anc
  has_one :ward, :through => :anc

  has_many :postings
  acts_as_mappable

  validates_numericality_of :street_number, only_integer: true
  validates_numericality_of :lat, :lng
  validates_presence_of :street_name, :slug, :anc_id
  validates_inclusion_of :street_type, in: STREET_TYPES_ABV.keys
  validates_inclusion_of :quad, in: QUADS
  validates_format_of :street_name, with: /\A[A-Z0-9 ']*[A-Z]\.?\z/, message: "`%{value}` is not a valid street name."
  validates_uniqueness_of :street_number, scope: [:street_name, :street_type, :quad]

  before_validation :normalize
  before_validation :ensure_lonlat
  before_validation :ensure_anc

  extend FriendlyId
  friendly_id :address, use: [:slugged, :finders]

  def self.find_or_create_by_address!(address)
    location = Location.new
    location.address = address
    location.normalize
    Location.find_or_create_by! location.attributes.reject { |k,v| v.nil? }
  end

  def address
    @address ||= [self.street_number, self.street_name, self.street_type, self.quad].join(" ")
  end

  def address=(address)
    address = address.strip
    address = address.split(";").reject { |s| s.empty? }.first
    address = address.gsub(/\A(\d+)\s?(-|–|&)\s?\d+/, '\1')        # Flatten ranges
    address = address.gsub(/(\d+), \d+,? and \d+/i, '\1')
    address = address.split(/\band\b/i).first
    address = address.gsub(/([NS])\.([EW])\.?/, '\1\2')            # Normalize N.W. to NW
    address = address.gsub(/, ([NS][EW])/, ' \1')                  # Remove comma before quad
    address = address.split(/([NS][EW]),/)[0..1].join if address =~ /[NS][EW],/ #Split after quad
    address = address.gsub(/\Arear of /i, '')
    address = address.gsub(/\b(ave\w+)\b/i, "AVE")                 # Normalize spelling of Avenue
    address = address.gsub(/,\sspace\s/i, " UNIT ")                # Call a unit a unit
    address = address.gsub(/\A(\d+)(-|–)?([a-z])\b/i, '\1') # Remove unit letter
    address = address.strip.upcase
    raise InvalidAddress if address =~ /\bVA\b/
    raise InvalidAddress unless address =~ /\A\d/

    # We need to use a DC-specific address parser, rather than a generic Ruby one
    # Because most non-DC-Specific parsers err out on things like S St., thinking it's "south street"
    parts = DcAddressLookup.lookup address
    return unless parts

    self.street_number = parts.addrnum
    self.street_name   = parts.stname
    self.street_type   = parts.street_type.to_s.empty? ? "ST" : parts.street_type
    self.quad          = parts.quadrant
  end

  def normalize
    normalize_street_type && normalize_street_name && normalize_street_number && normalize_quad
  end

  def point
    @point ||= RGeo::Geographic.spherical_factory(srid: 4326).point(lng, lat)
  end

  private

  def mar
    @mar ||= DcAddressLookup.lookup address
  rescue RestClient::InternalServerError
    nil
  end

  def ensure_lonlat
    return unless lng.nil? && lat.nil?
    self.lng = mar.longitude
    self.lat = mar.latitude
  end

  def ensure_anc
    return unless anc.nil?
    self.anc = Anc.find_or_create_by! :name => mar.anc
  end

  def normalize_street_name
    return unless self.street_name

    # If this is a plain numeric street number, e.g., "14", ordinalize it for consistency (e.g., "14th")
    if self.street_name.to_i.to_s == self.street_name
      self.street_name = ActiveSupport::Inflector.ordinalize self.street_name
    end

    # Strip trailing street types from street name
    street_type_full = STREET_TYPES_ABV[self.street_type]
    self.street_name = self.street_name.gsub(/\b(#{street_type_full}|#{street_type})\.?\z/i, "")

    regex = /\A(#{DIRECTIONS.values.join("|")})(?=\s+\w+)/
    self.street_name = self.street_name.sub(regex, DIRECTIONS.invert)

    self.street_name = self.street_name.sub(/\AMT\b/, "MOUNT")
    self.street_name = self.street_name.sub(/,\z/, "")
    self.street_name = self.street_name.sub(/M\.?L\.? KING/, "MARTIN LUTHER KING")
    self.street_name = self.street_name.sub(/JR\z/, "JR.")

    self.street_name = self.street_name.upcase.squeeze("\s").squeeze("'").strip
  end

  # Some street numbers are ranges. For simplicity, just use the first number in the range.
  # This allows us to store the column as integers, rather than strings, and simplifies geolocation
  # Oh, and did I mention they don't always use a standard hyphen?
  def normalize_street_number
    return unless self.street_number
    self.street_number = self.street_number.to_s.to_i
  end

  def normalize_street_type
    return unless self.street_type
    self.street_type = self.street_type.downcase.gsub(STREET_TYPES_REGEX, STREET_TYPES.stringify_keys)
    self.street_type = self.street_type.upcase.sub(/\W/, "")
  end

  def normalize_quad
    return unless self.quad
    self.quad = self.quad.upcase.gsub(".","")
  end
end
