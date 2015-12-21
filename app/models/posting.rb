class Posting < ActiveRecord::Base

  TYPES = {
    "AbraNotice" => "ABRA Notice",
    "BoardOfZoningAdjustmentCase" => "Board of Zoning Adjustment Case",
    "ZoningCommissionCase" => "Zoning Comission Case"
  }

  belongs_to :location
  has_one :anc, :through => :location
  has_one :ward, :through => :anc

  validates_inclusion_of :type, in: TYPES.keys, message: '%{value} is not a valid type'
  validates_format_of :slug, with: /\A[a-z0-9-]+\z/
  validates :posting_date, date: true, allow_nil: true
  validates :hearing_date, date: true, allow_nil: true
  validates_presence_of :location, :type, :slug, :anc

  serialize  :details, JSON
  alias_attribute :text, :body
  acts_as_mappable through: :location

  extend FriendlyId
  friendly_id :name_for_slug, use: [:slugged, :finders]

  def to_geojson
    raise "TODO"
  end

  def name
    name_for_slug.first
  end

  def address
    location.address
  end

  def as_geojson
    properties = { name: name, address: location.address }
    RGeo::GeoJSON::Feature.new location.point, location.slug, properties
  end

  def to_geojson
    RGeo::GeoJSON.encode as_geojson
  end

  private

  def name_for_slug
    if type == "AbraNotice"
      [licensee.trade_name, licensee.name]
    else
      [applicant]
    end
  end
end
