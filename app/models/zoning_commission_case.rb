class ZoningCommissionCase < ZoningCase

  YEAR = Date.today.strftime("%y")
  CASE_NUMBER_REGEX = /\d\d-\d\d-?[A-Z]?/i

  validates_format_of :number, with: CASE_NUMBER_REGEX

  def self.model_name
    ZoningCase.model_name
  end

  def self.all_listed
    form = ZoningCase.agent.get(URL).form
    form.txtsearch = "#{YEAR}-"
    page = ZoningCase.agent.submit(form, form.buttons.first)

    cases = []
    while page do
      results = page.search("#ucPendingCases_dgOnlineCases").first.children[2...-2]
      results.each do |result|
        tds = result.search("td")
        next unless tds[1].text.strip =~ CASE_NUMBER_REGEX
        cases.push({ number: tds[1].text.strip, type: ABBREVIATIONS_TYPES[tds[2].text.strip.upcase] })
      end
      link = page.link_with(:text => 'Next')
      page = link ? link.asp_click : nil
    end

    # Because the site isn't stateless, we must traverse all pages, *and then* load details
    cases.map do |zoning_case|
      begin
        ZoningCommissionCase.find_or_create_by! zoning_case
      rescue ZoningCase::InvalidCase, Location::InvalidAddress
        Rails.logger.error "Failed to load ZC Case #{zoning_case[:number]}"
      end
    end
  end
end
