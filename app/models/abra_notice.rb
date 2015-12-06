class AbraNotice < ActiveRecord::Base
  belongs_to :anc
  belongs_to :license_class
  belongs_to :licensee
  belongs_to :abra_bulletin
  has_one :ward, :through => :anc

  validates :pdf_page, numericality: { only_integer: true }

  before_validation :ensure_anc
  before_validation :ensure_license_class
  before_validation :ensure_dates
  before_validation :ensure_licensee

  DATE_FIELDS = [:posting, :petition, :hearing, :protest]

  def text
    @text ||= abra_bulletin.pdf.pages[pdf_page - 1].text
  end

  def pdf_url
    URI.join(abra_bulletin.pdf_url, "#page=#{pdf_page}").to_s
  end

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
    licensee = {
      :name            => key_values["licensee"],
      :trade_name      => key_values["trade name"],
      :address         => key_values["address"],
      :license_number  => license_number
    }
    self.licensee = Licensee.find_or_create_by! licensee
  end

  def key_values
    @key_values ||= begin
      key_values = {}
      pairs = text.scan(/^\s*\**([A-Z][^:\n]+):[ \t]*([^\n]+)$/)
      pairs.each do |key, value|
        key = key.strip.downcase.sub /\A\*+/, ""
        value = value.strip.sub /\A\*+/, ""
        key_values[key] = value
      end
      key_values
    end
  end

  def license_number
    matches = key_values.find { |k,v| k =~ /license\s*no\.?/i }
    matches[1] if matches
  end
end
