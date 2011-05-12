module GovernorBackground
  module Delayed
    class Performer < Struct.new(:article, :method_name, :arguments)
      def perform
        if arguments.blank?
          article.send(method_name)
        else
          article.send(method_name, *arguments)
        end
      end
    
      def error(job, exception)
        # handle failure
      end
    end
  end
end