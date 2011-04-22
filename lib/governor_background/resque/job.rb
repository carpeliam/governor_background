module GovernorBackground
  module Resque
    class Job
      @queue = :governor

      def self.perform(article, method)
        article.send(method)
      end
    end
  end
end