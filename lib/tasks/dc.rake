namespace :dc do
  desc "Crawl all AbraBulletins"
  task crawl: :environment do
    ActiveRecord::Base.logger = Rails.logger = Logger.new(STDOUT)
    ActiveRecord::Base.connection_pool.clear_reloadable_connections!
    AbraBulletin.all_listed
  end

  task licensees: :environment do
    
  end
end
