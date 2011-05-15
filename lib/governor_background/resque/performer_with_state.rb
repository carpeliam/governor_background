require 'resque/job_with_status'
module GovernorBackground
  module Resque
    # Used when the resque-status gem has been installed.
    class PerformerWithState < ::Resque::JobWithStatus
      def self.queue
        :governor
      end
      
      def perform
        job_name = options['job_name']
        arguments = options['arguments']
        GovernorBackground.retrieve(job_name).call(*arguments)
      end
    end
  end
end