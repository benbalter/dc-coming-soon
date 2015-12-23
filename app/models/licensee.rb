class Licensee < ActiveRecord::Base
  has_many :abra_notices, dependent: :destroy
  belongs_to :license_class_license_description, dependent: :destroy

  has_one :license_class, through: :license_class_license_description
  has_one :license_description, through: :license_class_license_description
  belongs_to :location

  has_one :anc, :through => :location
  has_one :ward, :through => :anc

  validates_presence_of :applicant, :trade_name, :location
  validates_presence_of  :license_class_license_description_id, :status
  validates_numericality_of :license_id, only_integer: true
  validates_uniqueness_of :license_id

  STATUSES = ["Active", "Safekeeping", "405.1 New Const", "Pending"]
  validates :status, inclusion: { in: STATUSES, message: "`%{value}` is not a valid license status." }

  acts_as_mappable through: :location

  LICENSEE_LIST = "http://abra.dc.gov/page/abc-licensees"
  LICENSE_NUMBER_REGEX = /ABRA[‐-]\s?(\d{6})/i

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
      url = latest_pdf
      Rails.logger.info "Loading licensee PDF from #{url}"
      pdf = Tempfile.new "abra-licensees-pdf"
      request = Typhoeus::Request.new url, Rails.application.config.typhoeus_defaults
      request.on_body { |chunk| pdf.write(chunk.force_encoding("utf-8")) }
      request.on_complete { |response| pdf.close }
      request.run

      extractor = Tabula::Extraction::ObjectExtractor.new(pdf.path, :all )
      pages = extractor.extract
      pdf.unlink

      Rails.logger.info "Parsing #{pages.count} pages"
      pages.each do |pdf_page|
        pdf_page.spreadsheets.each do |spreadsheet|
          rows = spreadsheet.to_a.drop(1)
          headings = rows.shift.map { |c| c.sub("\r","") }
          headings = headings.map { |h| h.sub("#","number").parameterize.underscore.to_sym }
          rows.each { |row| licensee_from_row(row, headings) }
        end
      end
    end

    def find_by_license_number(license_number)
      return if license_number.nil?
      matches = license_number.match(LICENSE_NUMBER_REGEX)
      Licensee.find_by :license_id => matches[1] if matches
    end

    def licensee_from_row(row, headings)
      attributes = {}
      row = row.map { |c| c.sub("\r","") }
      row.each_with_index do |cell, i|
        attributes[headings[i]] = cell.strip
      end

      licensee = Licensee.find_by_license_number attributes[:license]
      return licensee unless licensee.nil?

      license_class_license_description = LicenseClassLicenseDescription.find_or_create_by!({
        :license_class =>  LicenseClass.find_or_create_by!({ :letter => attributes[:class] }),
        :license_description => LicenseDescription.find_or_create_by!({
          :description => attributes[:description]
        })
      })

      location = Location.find_or_create_by_address!({
        :number => attributes[:street_number],
        :street_name => attributes[:street_name],
        :street_type => attributes[:type],
        :quadrant => attributes[:quad]
      })

      licensee = Licensee.new({
        :applicant                         => attributes[:applicant],
        :trade_name                        => attributes[:trade_name],
        :license_number                    => attributes[:license],
        :status                            => attributes[:status],
        :license_class_license_description => license_class_license_description,
        :location                          => location
      })

      licensee.save!

      Rails.logger.info "Added #{licensee.license_number} - #{licensee.trade_name}"
      licensee
    end
  end

  def address
    location.address
  end

  def license_number
    "ABRA-#{license_id.to_s.rjust(6, "0")}"
  end

  def license_number=(license_number)
    return if license_number.nil?
    matches = license_number.match(LICENSE_NUMBER_REGEX)
    self.license_id = matches[1] if matches
  end
end
