class Location < ActiveRecord::Base
  class InvalidAddress < StandardError; end

  belongs_to :anc
  has_one :ward, :through => :anc

  has_many :postings
  acts_as_mappable

  validates_numericality_of :street_number, only_integer: true
  validates_numericality_of :lat, :lng
  validates_presence_of :street_name, :slug, :anc_id
  validates_inclusion_of :street_type, in: DcAddressParser::STREET_TYPES.keys
  validates_format_of :quad, with: DcAddressParser::Address::QUADRANT_REGEX
  validates_format_of :street_name, with: /\A[A-Z0-9 ']*[A-Z]\.?\z/, message: "`%{value}` is not a valid street name."
  validates_uniqueness_of :street_number, scope: [:street_name, :street_type, :quad]

  before_validation :ensure_lonlat
  before_validation :ensure_anc

  extend FriendlyId
  friendly_id :address, use: [:slugged, :finders]

  def self.find_or_create_by_address!(address)
    Rails.logger.info "ADDRESS: #{address}"
    address = DcAddressParser.parse(address)
    Rails.logger.info "PARSED ADDRESS: #{address}"
    Location.find_or_create_by!({
      street_number: address.number,
      street_name: address.street_name,
      street_type: address.street_type,
      quad: address.quadrant
    })
  end

  def address
    @address ||= DcAddressParser::Address.new({
      number: self.street_number,
      street_name: self.street_name,
      street_type: self.street_type,
      quadrant: self.quad
    })
  end

  def address=(string)
    address = DcAddressParser.parse(string)
    raise InvalidAddress if address.to_s =~ /\bVA\b/

    self.street_number = address.number
    self.street_name   = address.street_name
    self.street_type   = address.street_type
    self.quad          = address.quadrant
  end

  def point
    @point ||= RGeo::Geographic.spherical_factory(srid: 4326).point(lng, lat)
  end

  private

  def mar
    @mar ||= address.lookup
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

end
