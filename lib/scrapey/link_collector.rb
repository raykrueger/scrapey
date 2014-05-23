require "net/https"
require "nokogiri"
require "uri"

module Scrapey
  class LinkCollector

    class TooManyRedirects < StandardError ; end
    class InvalidContentType < StandardError ; end
    class ExternalRedirect < StandardError ; end

    CONTENT_TYPE_HTML = /text\/html/
    REDIRECT_LIMIT = 3

    def collect_links(target)
      link_evaluator = LinkEvaluator.new(target)

      uri = URI.parse(target)

      response = request(target, link_evaluator)
      html = Nokogiri::HTML(response)
      links = html.css("a[href != '#']")
      links = links.map do |link|
        href = link.attributes['href'].value
        link_evaluator.resolve(href) if link_evaluator.follow? href
      end
      links.compact.uniq
    end

    private

    def request(target, link_evaluator, redirectLimit = REDIRECT_LIMIT)
      raise TooManyRedirects if redirectLimit.zero?

      uri = URI.parse(target)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme.downcase == 'https'

      get = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(get)

      case response
      when Net::HTTPSuccess then response
      when Net::HTTPRedirection 
        location = response["Location"]
        if link_evaluator.follow? location
          return request(location, link_evaluator, redirectLimit - 1)
        else
          raise ExternalRedirect, location
        end
      else
        response.error!
      end
      
      content_type = response["Content-Type"]
      raise InvalidContentType, content_type unless CONTENT_TYPE_HTML =~ content_type

      response.body
    end

  end
end
