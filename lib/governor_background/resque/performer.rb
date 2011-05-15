module GovernorBackground
  module Resque
    class Performer
      @queue = :governor

      def self.perform(job_name, *arguments)
        GovernorBackground.retrieve(job_name).call(*arguments)
      end
    end
  end
end