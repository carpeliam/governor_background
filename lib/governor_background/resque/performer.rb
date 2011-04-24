module GovernorBackground
  module Resque
    class Performer
      @queue = :governor

      def self.perform(resource, id, method_name)
        article = Governor.resources[resource].to.find(id)
        article.send(method_name)
      end
    end
  end
end