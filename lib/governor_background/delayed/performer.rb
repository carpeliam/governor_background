module GovernorBackground
  module Delayed
    class Performer < Struct.new(:article, :method)
      def perform
        article.send(method)
      end
    
      def error(job, exception)
        # handle failure
      end
    end
  end
end