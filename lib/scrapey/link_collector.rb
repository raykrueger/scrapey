require "nokogiri"
require "rest-client"

module Scrapey
  class LinkCollector

    def collect_links(target)
      link_evaluator = LinkEvaluator.new(target)

      uri = URI.parse(target)

      response = request(target)

      html = Nokogiri::HTML(response)
      links = html.css("a[href != '#']")
      links = links.map do |link|
        href = link.attributes['href'].value
        link_evaluator.resolve(href) if link_evaluator.follow? href
      end
      links.compact.uniq
    end

    private

    def request(target)
      response = RestClient.get target
      response.return!
    end

  end
end
