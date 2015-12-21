class AbraNotice < Posting

  belongs_to :abra_bulletin
  belongs_to :licensee
  has_one :license_class, through: :licensee
  has_one :license_description, through: :licensee

  validates :pdf_page, numericality: { only_integer: true }
  validates_presence_of :licensee, :details

  before_validation :ensure_licensee, prepend: true
  before_validation :ensure_body, prepend: true
  before_validation :ensure_dates
  before_validation :ensure_location
  before_validation :ensure_anc
  before_validation :ensure_rescinded
  before_validation :ensure_details

  DETAILS_REGEX = /^\**([A-Z]{2}[A-Z\s\/\(\)]+)\n(?![A-Za-z]+\s[A-Za-z]+\:\s)(\w.*?)(?=\n\n|\z)/m
  KEY_VALUE_REGEX = /^\s*\**([A-Z][^:\n]+):[ \t]*([^\n]+)$/

  def pdf_url
    URI.join(abra_bulletin.pdf_url, "#page=#{pdf_page}").to_s
  end

  def to_s
    name.compact.first
  end

  private

  def ensure_anc
    return unless anc.nil?
    match = text.match(/ANC\s+\**(#{Anc::REGEX})/)
    match = text.match(/\b(#{Anc::REGEX})\b/) unless anc
    self.anc = Anc.find_or_create_by! :name => match[1].upcase
  end

  def ensure_dates
    ["posting", "hearing"].each do |field|
      next unless self.send("#{field}_date").nil?
      write_attribute "#{field}_date".to_sym, key_values["#{field} date"]
    end
  end

  def ensure_licensee
    return unless licensee.nil?

    self.licensee = Licensee.find_by_license_number license_number
    return unless licensee.nil?

    license_text = key_values["license class"] || key_values["class"]
    license_class_license_description = LicenseClassLicenseDescription.from_string license_text

    location = Location.find_or_create_by_address! key_values["address"]

    licensee = Licensee.new({
      :applicant                         => key_values["licensee"],
      :trade_name                        => key_values["trade name"],
      :location                          => location,
      :license_number                    => license_number,
      :license_class_license_description => license_class_license_description,
      :status                            => "Pending"
    })

    licensee.save!
    self.licensee = licensee
  end

  def ensure_body
    return unless body.nil?
    return if abra_bulletin.nil?
    self.body = abra_bulletin.pdf.pages[pdf_page - 1].text.squeeze("\s").strip
  end

  def ensure_details
    self.details = detail_pairs if details.nil? || details.empty?
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
    if matches && matches[1] =~ Licensee::LICENSE_NUMBER_REGEX
      matches[1]
    else
      "ABRA-999999"
    end
  end

  def ensure_rescinded
    self.status = "rescinded" if body =~ /RESCIND/
  end

  def ensure_location
    return unless location.nil?
    self.location = licensee.location
  end
end
