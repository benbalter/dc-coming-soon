# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rails.logger.info "Loading licensees..."
Licensee.parse_pdf
Rails.logger.info "#{Licensee.count} licensees loaded"
Rails.logger.info "#{Anc.count} ANCs loaded"
Rails.logger.info "#{Ward.count} Wards loaded"

Rails.logger.info "Loading ABRA Bulletins..."
AbraBulletin.all_listed
Rails.logger.info "#{AbraBulletin.count} ABRA Bulletins loaded"
Rails.logger.info "#{AbraNotice.count} ABRA Notices loaded"
