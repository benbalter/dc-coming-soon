namespace :dc do
  desc "Crawl all data sources"
  task seed: :environment do
    Rails.logger.info "Flushing cache..."
    Rails.cache.clear

    # Licensees
    Rails.logger.info "Loading licensees..."
    Licensee.parse_pdf
    Rails.logger.info "#{Licensee.count} licensees loaded"
    Rails.logger.info "#{Anc.count} ANCs loaded"
    Rails.logger.info "#{Ward.count} Wards loaded"

    # ABRA Bulletins
    Rails.logger.info "Loading ABRA Bulletins..."
    AbraBulletin.all_listed
    Rails.logger.info "#{AbraBulletin.count} ABRA Bulletins loaded"
    Rails.logger.info "#{AbraNotice.count} ABRA Notices loaded"

    # BZ Cases
    Rails.logger.info "Loading BZA Cases..."
    BoardOfZoningAdjustmentCase.highest_case_number
    Rails.logger.info "#{BoardOfZoningAdjustmentCase.count} BZA Cases loaded"

    # ZC Cases
    Rails.logger.info "Loading ZC Cases..."
    ZoningCommissionCase.all_listed
    Rails.logger.info "#{ZoningCommissionCase.count} ZC Cases loaded"
  end
end
