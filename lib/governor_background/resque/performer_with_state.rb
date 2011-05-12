module GovernorBackground
  module Resque
    class PerformerWithState < ::Resque::JobWithStatus
      def self.queue
        :governor
      end
      
      def perform
        resource = options['resource']
        id = options['id']
        method_name = options['method_name']
        article = Governor.resources[resource].to.find(id)
        if options.has_key?('arguments') && options['arguments'].present?
          article.send(method_name, arguments)
        else
          article.send(method_name)
        end
      end
    end
  end
end