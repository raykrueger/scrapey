module Scrapey
  module Logging

    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def logger
        Scrapey.logger
      end
    end

  end
end
