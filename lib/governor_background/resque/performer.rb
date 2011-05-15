module GovernorBackground
  module Resque
    # Used when the resque-status gem hasn't been installed. If resque-status
    # hasn't been installed, jobs won't be added to the JobManager, as there
    # won't be any way to track the state, and so progress will not be
    # reported.
    class Performer
      @queue = :governor

      def self.perform(job_name, *arguments)
        GovernorBackground.retrieve(job_name).call(*arguments)
      end
    end
  end
end