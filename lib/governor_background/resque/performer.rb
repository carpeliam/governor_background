module GovernorBackground
  module Resque
    class Performer
      @queue = :governor

      def self.perform(resource, id, method_name, arguments=[])
        article = Governor.resources[resource].to.find(id)
        if arguments.blank?
          article.send(method_name)
        else
          article.send(method_name, arguments)
        end
      end
    end
  end
end