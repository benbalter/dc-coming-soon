class Licensee < ActiveRecord::Base
  has_many :abra_notices

  before_validation :ensure_lonlat

  validates_uniqueness_of :license_number
  validates_presence_of :name, :trade_name, :address, :lonlat

  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lon

  CITY = "Washington, DC"

  private

  def address_with_city
    "#{address}, #{CITY}"
  end

  def ensure_lonlat
    return unless lon.nil? && lat.nil?
    options = { proximity: Rails.application.config.dc_centerpoint }
    response = Mapbox::Geocoder.geocode_forward address_with_city, options
    return unless response && !response.first["features"].empty?
    feature = response.first["features"].first
    self.lon = feature["center"][0]
    self.lat = feature["center"][1]
  end
end
