class AbraNotice < ActiveRecord::Base
  belongs_to :anc
  belongs_to :license_class
  belongs_to :licensee
  belongs_to :abra_bulletin
  has_one :ward, :through => :anc
  has_many :details

  acts_as_mappable :through => :licensee

  alias_attribute :text, :body
  validates :pdf_page, numericality: { only_integer: true }

  before_validation :ensure_body
  before_validation :ensure_anc
  before_validation :ensure_license_class
  before_validation :ensure_dates
  before_validation :ensure_licensee
  after_create      :ensure_details

  DATE_FIELDS = [:posting, :petition, :hearing, :protest]

  DETAILS_REGEX = /^([A-Z]{2}[A-Z\s\/]+)\n(?![A-Za-z]+\s[A-Za-z]+\:\s)(\w.*?)(?=\n\n|\z)/m
  KEY_VALUE_REGEX = /^\s*\**([A-Z][^:\n]+):[ \t]*([^\n]+)$/

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def pdf_url
    URI.join(abra_bulletin.pdf_url, "#page=#{pdf_page}").to_s
  end

  def to_geojson
    {
      :type => "Feature",
      :properties => {
        :name       => licensee.name,
        :trade_name => licensee.trade_name,
        :address    => licensee.address
      },
      :geometry => {
        :type => "Point",
        :coordinates => [
          licensee.lon,
          licensee.lat
        ]
      }
    }
  end

  scope :close_to, -> (latitude, longitude, distance_in_meters = 2000) {
    where(%{
      ST_DWithin(
        ST_GeographyFromText(
          'SRID=4326;POINT(' || cafes.longitude || ' ' || cafes.latitude || ')'
        ),
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        %d
      )
    } % [longitude, latitude, distance_in_meters])
  }


  private

  def ensure_anc
    return unless anc.nil?
    match = text.match(/ANC\s+\**(#{Anc::REGEX})/)
    match = text.match(/\b(#{Anc::REGEX})\b/) unless anc
    self.anc = Anc.find_or_create_by! :name => match[1].upcase
  end

  def ensure_license_class
    return unless license_class.nil?
    license_class = key_values["license class"] || key_values["class"]
    self.license_class = LicenseClass.find_or_create_by! :name => license_class
  end

  def ensure_dates
    DATE_FIELDS.each do |field|
      next unless self.send("#{field}_date").nil?
      write_attribute "#{field}_date".to_sym, key_values["#{field} date"]
    end
  end

  def ensure_licensee
    return unless licensee.nil?
    licensee = {
      :name            => key_values["licensee"],
      :trade_name      => key_values["trade name"],
      :address         => key_values["address"],
      :license_number  => license_number
    }
    self.licensee = Licensee.find_or_create_by! licensee
  end

  def ensure_body
    return unless body.nil?
    self.body = abra_bulletin.pdf.pages[pdf_page - 1].text.squeeze("\s").strip
  end

  def ensure_details
    return unless details.empty?
    detail_pairs.each do |key, value|
      Detail.find_or_create_by! :abra_notice_id => id, :key => key, :value => value
    end
  end

  def key_values
    @key_values ||= begin
      key_values = {}
      pairs = text.scan KEY_VALUE_REGEX
      pairs.each do |key, value|
        key = key.strip.downcase.sub(/\A\*+/, "").sub("protest hearing date", "protest date")
        value = value.strip.sub(/\A\*+/, "")
        key_values[key] = value
      end
      key_values
    end
  end

  def detail_pairs
    pairs = {}
    body.scan(DETAILS_REGEX).map do |match|
      key = match[0].strip.gsub("\n", " ").squeeze("\s").downcase.capitalize
      value = match[1].strip.gsub("\n", " ").squeeze("\s")
      pairs[key] = value
    end
    pairs
  end

  def license_number
    matches = key_values.find { |k,v| k =~ /license\s*no\.?/i }
    matches[1] if matches
  end

  def name
    [
      licensee.trade_name,
      licensee.name
    ]
  end
end
