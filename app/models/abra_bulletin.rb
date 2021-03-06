class AbraBulletin < ActiveRecord::Base
  validates :date, date: true
  validates :pdf_url, url: true
  validates :html_url, url: true

  validates_uniqueness_of :date, :pdf_url, :html_url
  validates_format_of :pdf_url, :with => /\.pdf\z/i

  before_validation :ensure_pdf_url
  before_validation :ensure_date

  after_save :ensure_notices

  has_many :abra_notices, dependent: :destroy
  alias_method :notices, :abra_notices

  DOMAIN = "http://abra.dc.gov"
  DEFAULT_ARGS = {
    "keys"                => "Protest",
    "type"                => "732",
    "sort_by"             => "field_date_value",
    "sort_order"          => "DESC",
    "page"                => "0",
    "after[value][date]"  => "2015-01-01",
    "before[value][date]" => "2015-12-31"
  }

  def pdf
    @pdf ||= Pdftotext::Document.new tempfile.path
  end

  private

  def tempfile
    return @tempfile if defined?(@tempfile) && @tempfile && File.exists?(@tempfile.path)
    @tempfile = Tempfile.new ["abra-bulletin-pdf-#{date}", ".pdf"]
    request = Typhoeus::Request.new pdf_url, Rails.application.config.typhoeus_defaults
    request.on_body { |chunk| @tempfile.write(chunk.force_encoding("utf-8")) }
    request.on_complete { @tempfile.close }
    request.run
    @tempfile
  end

  def ensure_pdf_url
    return unless self.pdf_url.nil?
    link = html_doc.css(".file a")
    self.pdf_url = link.attr("href") if link
  end

  def ensure_date
    return unless self.date.nil?
    title = html_doc.css("#page-title")
    return unless title
    date = title.text.split(" ").last.split("-").map(&:to_i)
    self.date = Date.new date[2], date[0], date[1]
  end

  def ensure_notices
    return unless self.abra_notices.empty?
    pdf.pages.each do |page|
      next if page.text.to_s.empty?
      begin
        AbraNotice.find_or_create_by! :abra_bulletin => self, :pdf_page => page.number
      rescue ZoningCase::InvalidCase, Location::InvalidAddress, DcAddressParser::Address::InvalidAddress
        Rails.logger.error "Failed to load ABRA Notice from #{pdf} page #{page.number}"
      end
    end
  end

  def html
    return @html if defined?(@html)
    response = Typhoeus.get html_url, Rails.application.config.typhoeus_defaults
    @html = response.body if response.success?
  end

  def html_doc
    @html_doc ||= Nokogiri.HTML html
  end

  class << self

    def from_url(url)
      AbraBulletin.find_or_create_by! :html_url => url
    end

    def all_listed
      (0..pages).to_a.map { |page| from_page(page) }.flatten
    end

    private

    def pages
      page = get_page(0)
      attributes = CGI.parse page.css(".pager-last a").attr("href").to_s
      attributes["page"][0].to_i
    end

    def from_page(page=0)
      page = get_page(page)
      links = page.css(".view-content a").map { |a| a.attr("href") }
      links = links.select { |url| url =~ /\A\/publication\// }
      links = links.map { |url| URI.join(DOMAIN, url).to_s if url[0] == "/" }
      links.map { |url| AbraBulletin.from_url(url) }
    end

    def get_page(page)
      url = uri_for_page(page)
      response = Typhoeus.get url, Rails.application.config.typhoeus_defaults
      return Nokogiri.HTML(response.body) if response.success?

      response = Typhoeus.get url, Rails.application.config.typhoeus_defaults
      Nokogiri.HTML(response.body) if response.success?
    end

    def uri_for_page(page)
      params = DEFAULT_ARGS.merge({"page" => page})
      URI.join DOMAIN, "/publications-list?#{params.to_query}"
    end
  end
end
