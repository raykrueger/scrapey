require "logger"
require "scrapey/logging"
require "scrapey/link_collector"
require "scrapey/link_evaluator"
require "scrapey/scraper"
require "scrapey/version"

module Scrapey
  
  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new STDOUT
  end
end
