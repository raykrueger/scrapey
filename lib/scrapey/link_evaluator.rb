require 'uri'

module Scrapey

  class LinkEvaluator

    STARTS_WITH_HTTP = /\Ahttp/i
    MAILTO = /\Amailto/i
    SCHEME_RELATIVE = /\A\/\//

    attr_reader :base_url, :uri

    def initialize(base_url)
      @base_url = base_url
      @uri = URI.parse(base_url)
    end

    def resolve(href)
      case href
      when STARTS_WITH_HTTP then href
      when SCHEME_RELATIVE  then "#{uri.scheme}:#{href}"
      when MAILTO           then nil
      else #assume it's relative
        URI.join(base_url, href).to_s
      end
    end

  end
end
