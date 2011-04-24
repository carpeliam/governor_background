module GovernorBackground
  module Delayed
    class Performer < Struct.new(:article, :method_name)
      def perform
        article.send(method_name)
      end
    
      def error(job, exception)
        # handle failure
      end
    end
  end
end