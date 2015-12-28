source 'http://rubygems.org'

ruby_version = `cat .ruby-version`.strip
if ruby_version =~ /jruby/i
  ruby '2.2.2', engine: 'jruby', engine_version: '9.0.4.0'
  gem 'pg', '0.17.1', :platform => :jruby, :github => 'headius/jruby-pg'
else
  ruby ruby_version
  gem 'pg'
end

gem 'rails', "~> 4.2"
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 2.7'
gem 'sprockets-rails', "~> 3.0"
gem 'coffee-rails', '~> 4.1'
gem 'jquery-rails', "~> 4.0"
gem 'turbolinks', "~> 2.5"
gem 'jbuilder', '~> 2.0'
gem 'puma', "~> 2.15"
gem 'date_validator', "~> 0.8"
gem 'validate_url', "~> 1.0"
gem 'typhoeus', "~> 0.8"
gem 'nokogiri', "~> 1.6"
gem 'friendly_id', "~> 5.1"
gem 'bootstrap-sass', "~> 3.3"
gem 'rgeo-activerecord', "~> 4.0"
gem 'dotenv-rails', "~> 2.0"
gem 'browserify-rails', "~> 2.0"
gem 'rgeo-geojson', "0.3.3"
gem 'will_paginate', "~> 3.0"
gem 'geokit-rails', "~> 2.1"
gem 'tabula-extractor', "~> 0.8", platform: :jruby, require: "tabula"
gem 'dalli', "~> 2.7"
gem 'dc_address_lookup', github: "benbalter/dc-address-lookup"
gem 'pdftotext', github: "benbalter/pdftotext"
gem 'dc_address_parser', github: "benbalter/dc-address-parser"
gem 'actionpack-action_caching', "~> 1.1"
gem 'mechanize', "~> 2.7"

group :development do
  gem 'pry', "~> 0.10"
end

group :production do
  gem 'rails_12factor', "~> 0.0"
  gem 'connection_pool', "~> 2.2"
end

group :test do
  gem 'webmock'
end
