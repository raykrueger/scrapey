module Scrapey
  class Scraper
    include Logging

    def scrape(target, maxDepth=3)
      followed = Hash.new{|hash, key| hash[key] = []}
      crawl target, followed, maxDepth
    end

    private

    def crawl(target, followed, maxDepth)
      return followed if maxDepth == 0
      collector = LinkCollector.new

      begin
        logger.debug{ "Crawling #{target}" }
        links = collector.collect_links(target)
        link_evaluator = LinkEvaluator.new(target)
        links.each do |link|
          followed[target] = links
          followIt = !followed.include?(link) && link_evaluator.follow?(link)
          if followIt
            crawl link, followed, maxDepth - 1 unless followed.include?(link)
          end
        end
      rescue => e
        logger.warn "Skipping #{target}, due to error #{e.inspect}"
      end

      followed
    end

  end
end
