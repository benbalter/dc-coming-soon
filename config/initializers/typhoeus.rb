require 'typhoeus'

class TyphoeusCache
  def get(request)
    Rails.cache.read(request)
  end

  def set(request, response)
    Rails.cache.write(request, response)
  end
end

#Typhoeus::Config.cache = TyphoeusCache.new

Rails.application.config.typhoeus_defaults = {
  accept_encoding: "gzip"
}
