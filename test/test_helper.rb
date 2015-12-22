ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def fixture_path(file=nil)
    path = "test/fixtures/#{file}"
    File.expand_path path, Rails.root
  end

  def fixture(file)
    File.read fixture_path(file)
  end
end
