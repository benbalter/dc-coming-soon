class Licensee < ActiveRecord::Base
  has_many :abra_notices
  belongs_to :license_class_license_description

  before_validation :ensure_lonlat

  validates_uniqueness_of :license_number
  validates_presence_of :applicant, :trade_name, :lon, :lat, :street_name
  validates_presence_of :street_type, :license_class_license_description_id, :status
  validates_format_of :license_number, :with => /ABRA‐\d{6}/
  validates :street_number, numericality: true
  validates :quad, inclusion: { in: %w[NW NE SW SE] }

  validates :status, inclusion: { in: %w[Active Safekeeping] }
  validates :street_type, inclusion: { in: %w[ST AVE BLVD RD PL] }

  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lon

  CITY = "Washington, DC"
  LICENSEE_LIST = "http://abra.dc.gov/page/abc-licensees"

  class << self
    def latest_pdf
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
    [street_number, street_name, street_type, quad, CITY].join(" ")
  end

  def address=(address)
    parts = address.split(" ")
    self.street_number = parts[0]
    self.street_name   = parts[1]
    self.street_type   = parts[2]
    self.quad          = parts[3]
  end

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
