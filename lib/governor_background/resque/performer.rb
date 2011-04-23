module GovernorBackground
  module Resque
    class Performer
      @queue = :governor

      def self.perform(resource, id, method)
        article = Governor.resources[resource].to.find(id)
        article.send(method)
      end
    end
  end
end