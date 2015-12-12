namespace :dc do
  desc "Crawl all AbraBulletins"
  task crawl: :environment do
    AbraBulletin.all_listed
  end
end
