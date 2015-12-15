class AbraNotice < ActiveRecord::Base

  belongs_to :licensee
  has_one :license_class_license_description, :through => :licensee
  has_one :license_class, :through => :license_class_license_description
  has_one :license_description, :through => :license_class_license_description

  has_one :anc, :through => :licensee
  has_one :ward, :through => :anc

  belongs_to :abra_bulletin
  has_many :details

  acts_as_mappable :through => :licensee

  alias_attribute :text, :body
  validates :pdf_page, numericality: { only_integer: true }
  validates_presence_of :licensee_id

  validates_inclusion_of :correction, :in => [true, false]
  validates_inclusion_of :rescinded, :in => [true, false]

  before_validation :ensure_body
  before_validation :ensure_dates
  before_validation :ensure_licensee
  before_validation :ensure_anc
  before_validation :ensure_correction
  before_validation :ensure_rescinded
  after_create      :ensure_details

  DATE_FIELDS = [:posting, :petition, :hearing, :protest]

  DETAILS_REGEX = /^([A-Z]{2}[A-Z\s\/]+)\n(?![A-Za-z]+\s[A-Za-z]+\:\s)(\w.*?)(?=\n\n|\z)/m
  KEY_VALUE_REGEX = /^\s*\**([A-Z][^:\n]+):[ \t]*([^\n]+)$/

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  default_scope { where({ rescinded: false }) }
  scope :rescinded, -> { where({ rescinded: true }) }
  scope :correction, -> { where({ correction: true }) }

  def pdf_url
    URI.join(abra_bulletin.pdf_url, "#page=#{pdf_page}").to_s
  end

  def to_geojson
    {
      :type => "Feature",
      :properties => {
        :name       => licensee.applicant,
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

  def ensure_dates
    DATE_FIELDS.each do |field|
      next unless self.send("#{field}_date").nil?
      write_attribute "#{field}_date".to_sym, key_values["#{field} date"]
    end
  end

  def ensure_licensee
    return unless licensee.nil?
    Rails.logger.info body

    license_number = "ABRA-000001" unless license_number =~ Licensee::LICENSE_NUMBER_REGEX
    self.licensee = Licensee.find_by_license_number license_number
    return unless licensee.nil?

    Rails.logger.info "LICENSE NUMBER: #{license_number}"

    license_text = key_values["license class"] || key_values["class"]
    license_class_license_description = LicenseClassLicenseDescription.from_string license_text

    licensee = Licensee.new({
      :applicant                         => key_values["licensee"],
      :trade_name                        => key_values["trade name"],
      :address                           => key_values["address"],
      :license_number                    => license_number,
      :license_class_license_description => license_class_license_description,
      :status                            => "Pending"
    })

    licensee.save!
    self.licensee = licensee
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
      licensee.applicant
    ]
  end

  def ensure_correction
    self.correction = !!(body =~ /CORRECTION/)
    nil
  end

  def ensure_rescinded
    self.rescinded = !!(body =~ /RESCIND/)
    nil
  end
end
