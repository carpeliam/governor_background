module GovernorBackground
  module Resque
    class PerformerWithState < ::Resque::JobWithStatus
      def self.queue
        :governor
      end
      
      def perform
        resource = options['resource']
        id = options['id']
        method = options['method']
        article = Governor.resources[resource].to.find(id)
        article.send(method)
      end
    end
  end
end