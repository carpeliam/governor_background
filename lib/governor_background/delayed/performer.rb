module GovernorBackground
  module Delayed
    class Performer < Struct.new(:job_name, :arguments)
      def perform
        GovernorBackground.retrieve(job_name).call(*arguments)
      end
    end
  end
end