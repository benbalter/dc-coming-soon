require 'typhoeus'

class TyphoeusCache
  def get(request)
    Rails.cache.read(request)
  end

  def set(request, response)
    return unless response.success?
    Rails.cache.write(request, response)
  end
end

Typhoeus::Config.cache = TyphoeusCache.new

Rails.application.config.user_agent = "Mozilla/5.0 (compatible; DcComingSoon; +https://github.com/benbalter/dc-coming-soon)"

Rails.application.config.typhoeus_defaults = {
  accept_encoding: "gzip",
  timeout: 30,
  headers: {
    "User-Agent" => Rails.application.config.user_agent
  }
}
